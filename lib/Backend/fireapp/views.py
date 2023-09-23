import asyncio
import datetime
import os
from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework import status
from django.views.decorators.csrf import csrf_exempt
import pyrebase
from django.conf import settings

config = {
    "apiKey": "AIzaSyBtnQ4ekqXybSYuvPW2h_PaDCopMdKp8jM",
    "authDomain": "cebuarena-database.firebaseapp.com",
    "databaseURL": "https://cebuarena-database-default-rtdb.firebaseio.com/",
    "projectId": "cebuarena-database",
    "storageBucket": "cebuarena-database.appspot.com",
    "messagingSenderId": "44015113924",
    "appId": "1:44015113924:web:e687208c82863db5d15b91",
    "measurementId": "G-MCHVKZT0ZF"
}

firebase=pyrebase.initialize_app(config)
authe = firebase.auth()
database=firebase.database()

@api_view(['POST'])
@csrf_exempt
def register(request):
    if request.method == 'POST':
        username = request.data.get('username')
        email = request.data.get('email')  # get email from request
        password = request.data.get('password')
        confirm_password = request.data.get('confirm_password')
        firstname = request.data.get('firstname')  # get first name from request
        lastname = request.data.get('lastname')  # get last name from request

        if password != confirm_password:
            error_message = "Passwords do not match."
            return Response({'error_message': error_message}, status=400)

        try:
            # Create the user with the provided email and password
            user = authe.create_user_with_email_and_password(email, password)

            # Save the registered user in the Realtime Database
            data = {
                'username': username,
                'email': email,  # also save email
                'firstname': firstname,  # save first name
                'lastname': lastname,  # save last name
                'is_manager': False,  # set is_manager to False by default
                'is_organizer': False,
            }
            database.child('users').child(user['localId']).set(data)

            # Return a success response
            return Response({'message': 'Registration successful'})
        except Exception as e:
            # Handle registration errors and return an appropriate response
            error_message = str(e)
            return Response({'error_message': error_message}, status=400)

    return Response({'error_message': 'Invalid request'}, status=400)



@api_view(['POST'])
@csrf_exempt
def login(request):
    if request.method == 'POST':
        email_from_request = request.data.get('email')  # Use a different variable name here

        # Fetch the email, firstname, lastname, and username associated with this email from the database
        users = database.child('users').get()
        email = None
        firstname = None
        lastname = None
        local_id = None
        is_manager = False
        is_organizer = False
        isMember = False
        username = None  # Initialize the username variable
        org_name = None  # Initialize the org_name variable

        for user in users.each():
            if user.val()['email'] == email_from_request:  # Use the new variable here
                firstname = user.val().get('firstname', '')
                lastname = user.val().get('lastname', '')
                is_manager = user.val().get('is_manager', False)
                is_organizer = user.val().get('is_organizer', False)
                isMember = user.val().get('isMember', False)
                username = user.val().get('username', '')  # Get the username from the database
                local_id = user.key()

                # Check if the user is an organizer and has an associated organization
                if is_organizer and 'organizations' in user.val():
                    org_id = next(iter(user.val()['organizations']), None)
                    if org_id:
                        org_data = database.child('organizations').child(org_id).get().val()
                        if org_data:
                            org_name = org_data.get('org_name', '')
                break

        if email_from_request is None:
            return Response({'error_message': 'Invalid email'}, status=status.HTTP_400_BAD_REQUEST)

        password = request.data.get('password')

        try:
            # Perform the login process
            user = authe.sign_in_with_email_and_password(email_from_request, password)

            # Return the username, localId, firstname, lastname, is_manager, is_organizer, and org_name in the response
            return Response({
                'message': 'Login successful',
                'email': email_from_request,
                'localId': local_id,
                'firstname': firstname,
                'lastname': lastname,
                'username': username,  # Include the username in the response
                'is_manager': is_manager,
                'is_organizer': is_organizer,
                'org_name': org_name,  # Include the org_name in the response
                'isMember': isMember,
            })
        except Exception as e:
            # Handle login errors and return an appropriate response
            error_message = str(e)
            return Response({'error_message': error_message}, status=status.HTTP_400_BAD_REQUEST)

    return Response({'error_message': 'Invalid request'}, status=status.HTTP_400_BAD_REQUEST)





@api_view(['GET'])
@csrf_exempt
def current_user(request):
    localId = request.headers.get('LocalId')

    if not localId:
        return Response({'error_message': 'LocalId must be provided'}, status=status.HTTP_401_UNAUTHORIZED)
    
    try:
        user_data = database.child('users').child(localId).get().val()

        if not user_data:
            return Response({'error_message': 'User not found in the database'}, status=status.HTTP_404_NOT_FOUND)

        # You can expand this to include additional fields
        firstname = user_data.get('firstname', '')
        lastname = user_data.get('lastname', '')
        username = user_data.get('username', '')
        email = user_data.get('email', '')
        is_manager = user_data.get('is_manager', False)
        is_organizer = user_data.get('is_organizer', False)
        is_member = user_data.get('isMember', False)  # Add this if you want

        return Response({
            'firstname': firstname,
            'lastname': lastname,
            'username': username,
            'email': email,
            'is_manager': is_manager,
            'is_organizer': is_organizer,
            'is_member': is_member  # Add this if you want
        })

    except Exception as e:
        error_message = str(e)
        return Response({'error_message': error_message}, status=status.HTTP_400_BAD_REQUEST)






@api_view(['GET'])
@csrf_exempt
def get_all_users(request):
    if request.method == 'GET':
        try:
            # Fetch all users from the database
            users = database.child('users').get()

            # Prepare the users data
            users_data = []
            for user in users.each():
                user_data = user.val()
                user_data['id'] = user.key()
                users_data.append(user_data)

            # Return the users data
            return Response(users_data)

        except Exception as e:
            # Handle errors and return an appropriate response
            error_message = str(e)
            return Response({'error_message': error_message}, status=500)

    return Response({'error_message': 'Invalid request'}, status=400)

@api_view(['POST'])
@csrf_exempt
def create_team(request):
    if request.method == 'POST':
        manager_id = request.data.get('manager_id')
        team_name = request.data.get('team_name')
        game = request.data.get('game')

        try:
            user_data = database.child('users').child(manager_id).get().val()
            if user_data:
                username = user_data.get('username')
                firstname = user_data.get('firstname')
                lastname = user_data.get('lastname')
            else:
                return Response({'error_message': 'Invalid manager_id'}, status=400)

            data = {
                'manager_id': manager_id,
                'manager_username': username,
                'manager_firstname': firstname,
                'manager_lastname': lastname,
                'team_name': team_name,
                'members': [],  # Initialize members as an empty list
                'pending_requests': [],  # Initialize pending_requests as an empty list
                'captain_id': None,
                'game': game
            }

            team_ref = database.child('teams').child(game).push(data)

            # Update the user's data to set 'role' to 'manager: true'
            user_ref = database.child('users').child(manager_id)
            user_ref.update({'is_manager': True})

            return Response({'message': 'Team created successfully.'})
        except Exception as e:
            return Response({'error_message': str(e)}, status=400)

    return Response({'error_message': 'Invalid request'}, status=400)

@api_view(['POST'])
@csrf_exempt
def join_team(request):
    if request.method == 'POST':
        team_id = request.data.get('team_id')
        localId = request.data.get('localId')

        try:
            # Verify that the localId corresponds to a valid user
            user_data = database.child('users').child(localId).get().val()
            if not user_data:
                return Response({'error_message': 'Invalid localId'}, status=400)

            # Retrieve the username, email, firstname, and lastname from the user data
            username = user_data.get('username')
            email = user_data.get('email')
            firstname = user_data.get('firstname')
            lastname = user_data.get('lastname')
            isMember = user_data.get('isMember', False)
            is_manager = user_data.get('is_manager', False)

            # If user is a manager or already a member, reject the request
            if isMember or is_manager:
                return Response({'error_message': 'User cannot join a team'}, status=400)

            # Retrieve all the teams data from Firebase
            all_teams = database.child('teams').get().val()

            if all_teams:
                # Add the user to the new team if they are not already part of one
                for game, teams in all_teams.items():
                    if team_id in teams:
                        team_data = teams[team_id]
                        pending_requests = team_data.get('pending_requests', [])
                        pending_requests.append({'team_id': team_id, 'localId': localId, 'username': username, 'email': email, 'firstname': firstname, 'lastname': lastname})

                        database.child('teams').child(game).child(team_id).update({'pending_requests': pending_requests})

                        # Update the isMember status for the user
                        database.child('users').child(localId).update({'isMember': True})

                        return Response({'message': 'Request sent successfully.'})

            return Response({'error_message': 'Invalid team_id'}, status=400)

        except Exception as e:
            return Response({'error_message': str(e)}, status=400)

    return Response({'error_message': 'Invalid request'}, status=400)




@api_view(['POST'])
@csrf_exempt
def respond_to_request(request):
    if request.method == 'POST':
        game = request.data.get('game') 
        team_id = request.data.get('team_id')
        localId = request.data.get('localId')
        accept = request.data.get('accept').lower() == 'true'
        manager_id = request.data.get('manager_id')

        try:
            team_data = database.child('teams').child(game).child(team_id).get().val()
            if not team_data:
                return Response({'error_message': 'Invalid team_id'}, status=400)

            if team_data['manager_id'] != manager_id:
                return Response({'error_message': 'Only the manager can accept or reject requests.'}, status=403)

            pending_requests = team_data.get('pending_requests', [])
            
            # Find the index of the request corresponding to the localId
            request_index = None
            for i, request in enumerate(pending_requests):
                if request.get('localId') == localId:
                    request_index = i
                    break

            if request_index is not None:
                pending_requests.pop(request_index)
                database.child('teams').child(game).child(team_id).update({'pending_requests': pending_requests})
            else:
                return Response({'error_message': 'Invalid localId'}, status=400)

            if accept:
                player_data = database.child('users').child(localId).get().val()
                if not player_data:
                    return Response({'error_message': 'Invalid localId'}, status=400)

                player_details = {
                    'username': player_data.get('username'),
                    'firstname': player_data.get('firstname'),
                    'lastname': player_data.get('lastname'),
                    'id': localId
                }

                members = team_data.get('members', [])
                members.append(player_details)
                database.child('teams').child(game).child(team_id).update({'members': members})

                # Update isMember attribute in the user's data
                database.child('users').child(localId).update({'isMember': True})

            return Response({'message': 'Request processed successfully.'})
        except Exception as e:
            return Response({'error_message': str(e)}, status=400)

    return Response({'error_message': 'Invalid request'}, status=400)


@api_view(['GET'])
def get_all_teams(request):
    if request.method == 'GET':
        try:
            games_data = database.child('teams').get().val()
            if not games_data:
                return Response({'error_message': 'No teams found'}, status=404)

            teams_list = []
            for game, teams in games_data.items():
                for team_id, team in teams.items():
                    team_info = {
                        'team_id': team_id,  # This is the key of the team in the 'teams' node
                        'team_name': team.get('team_name'),
                        'manager': {
                            'username': team.get('manager_username'),
                            'firstname': team.get('manager_firstname'),
                            'lastname': team.get('manager_lastname'),
                            'id': team.get('manager_id'),
                        },
                        'members': team.get('members'),
                        'game': game
                    }
                    teams_list.append(team_info)
                    print(team_info)

            return Response({'teams': teams_list}, status=200)
        except Exception as e:
            return Response({'error_message': str(e)}, status=400)

    return Response({'error_message': 'Invalid request'}, status=400)




@api_view(['GET'])
@csrf_exempt
def get_team_info(request, manager_id):
    if request.method == 'GET':
        try:
            # Retrieve all the game categories data from Firebase
            all_games = database.child('teams').get().val()
            
            if all_games:
                # Loop through each game category
                for game, teams in all_games.items():
                    # Find the team that has the given manager_id
                    for team_id, team_info in teams.items():
                        if team_info.get('manager_id') == manager_id:
                            return Response(team_info)
                
                # If no team is found with the given manager_id
                return Response({'error_message': 'No team found for the given manager_id'}, status=400)
            
            else:
                return Response({'error_message': 'No teams found'}, status=400)

        except Exception as e:
            return Response({'error_message': str(e)}, status=400)

    return Response({'error_message': 'Invalid request'}, status=400)

@api_view(['GET'])
@csrf_exempt
def get_team_info_member(request, localId):
    if request.method == 'GET':
        try:
            # Retrieve all the game categories data from Firebase
            all_games = database.child('teams').get().val()
            
            if all_games:
                # Loop through each game category
                for game, teams in all_games.items():
                    # Find the team that has the user with given localId in its members
                    for team_id, team_info in teams.items():
                        members = team_info.get('members', [])
                        for member in members:
                            if member.get('id') == localId:
                                return Response(team_info)
                
                # If no team is found with the user having given localId
                return Response({'error_message': 'No team found for the given localId'}, status=400)
            
            else:
                return Response({'error_message': 'No teams found'}, status=400)

        except Exception as e:
            return Response({'error_message': str(e)}, status=400)

    return Response({'error_message': 'Invalid request'}, status=400)


@api_view(['POST'])
@csrf_exempt
def create_scrim(request):
    if request.method == 'POST':
        manager_id = request.data.get('manager_id')
        team_name = request.data.get('team_name')
        game = request.data.get('game')
        date = request.data.get('date')
        time = request.data.get('time')
        preferences = request.data.get('preferences')
        contact = request.data.get('contact')

        try:
            user_data = database.child('users').child(manager_id).get().val()
            if user_data:
                username = user_data.get('username')
                is_manager = user_data.get('is_manager', False)
            else:
                return Response({'error_message': 'Invalid manager_id'}, status=400)

            # Check if the user is a manager
            if not is_manager:
                # If not a manager, check if the user has created a team
                teams = database.child('teams').child(game).get().val()
                if not any(team.get('manager_id') == manager_id for team in teams.values()):
                    return Response({'error_message': 'Only managers can create a scrim'}, status=400)

            data = {
                'manager_id': manager_id,
                'manager_username': username,
                'team_name': team_name,
                'game': game,
                'date': date,
                'time': time,
                'preferences': preferences,
                'contact': contact,
            }

            scrim_ref = database.child('scrims').child(game).push(data)
            scrim_id = scrim_ref['name']  # get the ID of the newly created scrim

            return Response({'message': 'Scrim created successfully.', 'scrim_id': scrim_id})  # return the scrim ID
        except Exception as e:
            return Response({'error_message': str(e)}, status=400)

    return Response({'error_message': 'Invalid request'}, status=400)


@api_view(['POST']) #REQUEST ID ANG E FIX KAY MANGAYO PA DAPAT NAA NAMAN NA DAAN MATOG SAKO
@csrf_exempt
def request_scrim(request):
    if request.method == 'POST':
        manager_id = request.data.get('manager_id')
        scrim_id = request.data.get('scrim_id')
        game = request.data.get('game')

        try:
            # Get the requested scrim details
            scrim_data = database.child('scrims').child(game).child(scrim_id).get().val()
            if not scrim_data:
                return Response({'error_message': 'Invalid scrim_id'}, status=status.HTTP_400_BAD_REQUEST)

            # Get the user details
            user_data = database.child('users').child(manager_id).get().val()
            if user_data:
                username = user_data.get('username')
                is_manager = user_data.get('is_manager', False)
            else:
                return Response({'error_message': 'Invalid manager_id'}, status=status.HTTP_400_BAD_REQUEST)

            # Get all teams for the game
            teams = database.child('teams').child(game).get().val()
            team_name = None
            for team_id, team in teams.items():
                if team.get('manager_id') == manager_id:
                    team_name = team.get('team_name')
                    break

            # Check if the user is a manager and if a team is associated with the manager
            if not is_manager or not team_name:
                return Response({'error_message': 'You are not authorized to make this request.'}, status=status.HTTP_400_BAD_REQUEST)

            data = {
                'requesting_manager_id': manager_id,
                'requesting_manager_username': username,
                'game_name': game,
                'requesting_team_name': team_name,
                'scrim_id': scrim_id,
                'status': 'pending',
            }

            # Send the request to the manager who created the scrim
            ref = database.child('scrims').child(game).child(scrim_id).child('scrim_requests').push(data)

            # Get the key of the newly created object

        except Exception as e:
            return Response({'error_message': str(e)}, status=status.HTTP_400_BAD_REQUEST)

    return Response({'error_message': 'Invalid request'}, status=status.HTTP_400_BAD_REQUEST)



@api_view(['GET'])
@csrf_exempt
def get_scrim_requests(request, manager_id):
    try:
        # Get all the scrims
        all_scrims = database.child('scrims').get().val()
        
        if not all_scrims:
            print('No scrims found in database.')
            return Response({'error_message': 'No scrims found'}, status=400)

        # Initialize the list of manager requests
        manager_requests = []

        # Loop through all games
        for game, scrims in all_scrims.items():
            # Loop through all scrims in a game
            for scrim_id, scrim_data in scrims.items():
                # Check if the scrim has requests
                scrim_requests = scrim_data.get('scrim_requests')
                if scrim_requests:
                    # Loop through all requests of a scrim
                    for request_id, request_data in scrim_requests.items():
                        # Check if the request is for the given manager
                        if scrim_data.get('manager_id') == manager_id:
                            # Add the request to the list of manager requests
                            manager_requests.append(request_data)

        # If no manager requests are found, return an empty list
        if not manager_requests:
            print(f'No Scrim Requests for manager_id: {manager_id}')
            return Response({'message': 'No Scrim Requests for the given manager', 'data': []})

        print(f'Scrim requests fetched successfully for manager_id: {manager_id}')
        return Response({'message': 'Scrim requests fetched successfully', 'data': manager_requests})

    except Exception as e:
        print(f'Error while fetching scrim requests for manager_id: {manager_id}. Error: {str(e)}')
        return Response({'error_message': str(e)}, status=400)




    
@api_view(['POST'])
@csrf_exempt
def respond_scrim_request(request, manager_id):
    if request.method == 'POST':
        request_id = request.data.get('request_id')
        response = request.data.get('response')

        try:
            # Check if the response is either 'accepted' or 'declined'
            if response not in ['accepted', 'declined']:
                return Response({'error_message': 'Invalid response. The response should be either "accepted" or "declined".'}, status=400)

            # Get the request details
            all_scrim_requests = database.child('scrim_requests').get().val()

            if not all_scrim_requests:
                return Response({'error_message': 'No scrim requests found'}, status=400)

            for scrim_id, scrim_requests in all_scrim_requests.items():
                if request_id in scrim_requests:
                    # Update the request status
                    database.child('scrim_requests').child(scrim_id).child(request_id).update({'status': response})

                    # Also update the request status in the 'requests' node of the relevant team
                    all_teams = database.child('teams').get().val()
                    for game, teams in all_teams.items():
                        for team_id, team_data in teams.items():
                            if request_id in team_data.get('requests', {}):
                                database.child('teams').child(game).child(team_id).child('requests').child(request_id).update({'status': response})

                    return Response({'message': f'Scrim request {response} successfully.'})
            
            return Response({'error_message': 'Invalid request_id'}, status=400)

        except Exception as e:
            return Response({'error_message': str(e)}, status=400)

    return Response({'error_message': 'Invalid request'}, status=400)



@api_view(['POST'])
@csrf_exempt
def accept_scrim(request):
    if request.method == 'POST':
        request_id = request.data.get('request_id')
        manager_id = request.data.get('manager_id')

        try:
            # Fetch the request from the database
            request_data = database.child('teams').child(manager_id).child('requests').child(request_id).get().val()

            print(f"Retrieved request data: {request_data}")

            if not request_data:
                return Response({request_data}, status=400)

            # Update the status of the request to 'accepted'
            database.child('teams').child(manager_id).child('requests').child(request_id).update({'status': 'accepted'})

            # You might also want to update the scrim status or send notifications at this point

            return Response({'message': 'Scrim request accepted successfully.'})
        except Exception as e:
            return Response({'error_message': str(e)}, status=500)  # I changed this to a 500 error, because if there's an exception here, it likely indicates a server error, not a client error

    return Response({'error_message': 'Invalid request'}, status=400)




@api_view(['GET'])
@csrf_exempt
def get_scrim_details(request, game, scrim_id):
    if request.method == 'GET':
        try:
            # Retrieve the scrim details for the given game and scrim_id from Firebase
            scrim = database.child('scrims').child(game).child(scrim_id).get().val()

            if scrim:
                # Fetch the team name based on the manager_id from the scrimmage details
                manager_id = scrim.get('manager_id')
                team = database.child('teams').child(manager_id).get().val()

                return Response(scrim)
            else:
                return Response({'error_message': 'No scrim found for the given id'}, status=400)

        except Exception as e:
            return Response({'error_message': str(e)}, status=400)

    return Response({'error_message': 'Invalid request'}, status=400)



@api_view(['GET'])
@csrf_exempt
def get_all_scrims(request, game):
    if request.method == 'GET':
        try:
            # Retrieve all scrims for the given game from Firebase
            scrims = database.child('scrims').child(game).get().val()

            if scrims:
                result_scrims = []
                for scrim_id, scrim_data in scrims.items():
                    manager_id = scrim_data.get('manager_id')
                    team_name = None

                    if manager_id:
                        # Fetch the team name based on the manager_id from the database
                        team_data = database.child('teams').child(manager_id).get().val()
                        if team_data:
                            team_name = team_data.get('team_name')

                    # Add the team name to the scrimmage data
                    scrim_data['team_name'] = team_name
                    scrim_data['scrim_id'] = scrim_id
                    result_scrims.append({scrim_id: scrim_data})

                return Response(result_scrims)
            else:
                return Response({'error_message': 'No scrims found for the given game'}, status=400)

        except Exception as e:
            return Response({'error_message': str(e)}, status=400)

    return Response({'error_message': 'Invalid request'}, status=400)

@api_view(['POST'])
@csrf_exempt
def accept_scrim_request(request):
    try:
        game_name = request.data.get('game_name')
        scrim_id = request.data.get('scrim_id')  # You need the scrim_id to access the correct scrim
        request_id = request.data.get('request_id')
        
        if not game_name or not scrim_id or not request_id:
            return Response({'error_message': 'game_name, scrim_id, and request_id are required'}, status=status.HTTP_400_BAD_REQUEST)
        
        # Fetch the request from the database
        request_data = database.child('scrims').child(game_name).child(scrim_id).child('scrim_requests').child(request_id).get().val()
        
        if not request_data:
            return Response({'error_message': 'Request not found'}, status=status.HTTP_400_BAD_REQUEST)
        
        # Update the status of the request to 'accepted'
        database.child('scrims').child(game_name).child(scrim_id).child('scrim_requests').child(request_id).update({'status': 'accepted'})
        
        # Here, you might also want to perform additional actions, such as updating other related data or sending notifications
        
        return Response({'message': 'Scrim request accepted successfully.'}, status=status.HTTP_200_OK)
    
    except Exception as e:
        return Response({'error_message': str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)



@api_view(['POST'])
@csrf_exempt
def create_organization(request):
    if request.method == 'POST':
        localId = request.data.get('localId')
        org_name = request.data.get('org_name')
        org_description = request.data.get('org_description')

        try:
            # Fetch the owner's details from the database
            owner_data = database.child('users').child(localId).get().val()
            if not owner_data:
                return Response({'error_message': 'Invalid localId'}, status=400)

            # Create the organization
            org_data = {
                'org_name': org_name,
                'owner': {
                    'username': owner_data.get('username', ''),
                    'firstname': owner_data.get('firstname', ''),
                    'lastname': owner_data.get('lastname', ''),
                    'localId': localId  # Optionally store the localId of the owner
                },
                'members': [],  # Set members to None for now
                'pending_requests': [],  # Set pending_requests to None for now
                'org_description': org_description,
                'is_approved': False  # The org needs to be approved by the admin first
            }

            # Save the organization data in the "pending_approval" section of the database
            pending_org_ref = database.child('pending_approval').push(org_data)

            # Get the unique key generated by Firebase for the newly created organization
            org_id = pending_org_ref.get('name')  # Retrieve the key using 'name' attribute

            # Associate the organization with the user in the user's 'organizations' field and set 'isOrganizer' to False
            database.child('users').child(localId).child('organizations').child(org_id).set({
                'isOrganizer': False,
                'org_id': org_id,
                'org_name': org_name
            })

            return Response({'message': 'Organization created successfully. The organization is pending admin approval.',
                             'org_id': org_id})

        except Exception as e:
            return Response({'error_message': str(e)}, status=400)

    return Response({'error_message': 'Invalid request'}, status=400)

@api_view(['GET'])
@csrf_exempt
def get_all_pending_approvals(request):
    try:
        # Fetch all the pending organization data from the database
        pending_approvals = database.child('pending_approval').get().val()
        if not pending_approvals:
            return Response({'message': 'No pending approvals found.'}, status=200)
        
        return Response(pending_approvals)
    except Exception as e:
        return Response({'error_message': str(e)}, status=400)




@api_view(['POST'])
@csrf_exempt
def approve_organization(request):
    if request.method == 'POST':
        localId = request.data.get('localId')
        org_id = request.data.get('org_id')

        try:
            # Check if the admin user has admin privileges (isAdmin set to True)
            admin_user_data = database.child('users').child(localId).get().val()
            if admin_user_data and admin_user_data.get('isAdmin', False):
                # Fetch the pending organization data from the database
                pending_org_data = database.child('pending_approval').child(org_id).get().val()
                if not pending_org_data:
                    return Response({'error_message': 'Invalid org_id'}, status=400)

                # Move the approved organization data to the "organizations" section
                database.child('organizations').child(org_id).set(pending_org_data)

                # Set the 'is_approved' flag to True in the approved organization data
                database.child('organizations').child(org_id).update({'is_approved': True})

                # Remove the organization data from the "pending_approval" section
                database.child('pending_approval').child(org_id).remove()

                # Find the user who created this organization and set 'isOrganizer' to True
                owner_id = pending_org_data['owner']['localId']
                database.child('users').child(owner_id).child('organizations').child(org_id).update({'isOrganizer': True})

                # Set the 'is_organizer' flag to True in the user data
                database.child('users').child(owner_id).update({'is_organizer': True})

                return Response({'message': 'Organization approved successfully.'})
            else:
                return Response({'error_message': 'You do not have admin privileges to approve an organization.'}, status=403)

        except Exception as e:
            return Response({'error_message': str(e)}, status=400)

    return Response({'error_message': 'Invalid request'}, status=400)





@api_view(['GET'])
@csrf_exempt
def get_all_organizations(request):
    if request.method == 'GET':
        try:
            # Fetch all organizations from the database
            organizations = database.child('organizations').get()

            # Prepare the organizations data
            organizations_data = []
            for org in organizations.each():
                org_data = org.val()
                org_data['id'] = org.key()
                organizations_data.append(org_data)

            # Return the organizations data
            return Response(organizations_data)

        except Exception as e:
            # Handle errors and return an appropriate response
            error_message = str(e)
            return Response({'error_message': error_message}, status=500)

    return Response({'error_message': 'Invalid request'}, status=400)


@api_view(['POST'])
@csrf_exempt
def join_organization(request):
    if request.method == 'POST':
        localId = request.data.get('localId')
        org_id = request.data.get('org_id')

        try:
            # Fetch the organization data from the database
            org_data = database.child('organizations').child(org_id).get().val()
            if not org_data:
                return Response({'error_message': 'Invalid org_id'}, status=400)

            # Fetch the user data from the database
            user_data = database.child('users').child(localId).get().val()
            if not user_data:
                return Response({'error_message': 'Invalid localId'}, status=400)

            # If the organization is not approved, add the user's request to the pending_requests section
            if 'pending_requests' not in org_data:
                org_data['pending_requests'] = {}  # Initialize the pending_requests field as a dictionary

            # Add the user's request details to the pending_requests
            org_data['pending_requests'][localId] = {
                'firstname': user_data.get('firstname', ''),
                'lastname': user_data.get('lastname', ''),
                'username': user_data.get('username', ''),
                'isOrganizer': user_data.get('is_organizer', False),
            }

            # Save the updated organization data in the database
            database.child('organizations').child(org_id).update(org_data)

            return Response({'message': 'Your request to join the organization is pending approval.'}, status=202)

        except Exception as e:
            return Response({'error_message': str(e)}, status=400)

    return Response({'error_message': 'Invalid request'}, status=400)


@api_view(['POST'])
@csrf_exempt
def approve_member(request):
    if request.method == 'POST':
        owner_localId = request.data.get('owner_localId')
        org_id = request.data.get('org_id')
        member_localId = request.data.get('member_localId')

        try:
            org_data = database.child('organizations').child(org_id).get().val()
            if not org_data:
                print(f"Invalid org_id: {org_id}")  # Debugging line
                return Response({'error_message': 'Invalid org_id'}, status=400)

            owner_data = database.child('users').child(owner_localId).get().val()
            if not owner_data or org_data['owner']['localId'] != owner_localId:
                print(f"Invalid owner_localId: {owner_localId}")  # Debugging line
                return Response({'error_message': 'You do not have permission to approve members.'}, status=403)

            if org_data.get('is_approved', False):
                member_data = database.child('users').child(member_localId).get().val()
                if not member_data:
                    print(f"Invalid member_localId: {member_localId}")  # Debugging line
                    return Response({'error_message': 'Invalid member_localId'}, status=400)
  # Update the user data to be a member of the organization and mark them as an organizer
                if 'organizations' not in member_data:
                    member_data['organizations'] = {}

                member_data['organizations'][org_id] = {'isOrganizer': True}
                member_data['is_organizer'] = True

                # Add the organization ID and name to the user data
                member_data['organizations'][org_id]['org_name'] = org_data['org_name']
                member_data['organizations'][org_id]['org_id'] = org_id

                # Save the updated member data in the database
                database.child('users').child(member_localId).update(member_data)

                # Move the approved member's details to the 'members' section of the organization
                if 'members' not in org_data:
                    org_data['members'] = {}
                org_data['members'][member_localId] = {
                    'firstname': member_data.get('firstname', ''),
                    'lastname': member_data.get('lastname', ''),
                    'username': member_data.get('username', ''),
                    'isOrganizer': True,
                }

                # Remove the member's request from the organization's pending_requests section
                if 'pending_requests' in org_data and member_localId in org_data['pending_requests']:
                    del org_data['pending_requests'][member_localId]

                database.child('organizations').child(org_id).update(org_data)

                return Response({'message': 'Member approved successfully.'})
               

            else:
                return Response({'error_message': 'The organization is not approved yet. Please wait for approval.'}, status=403)

        except Exception as e:
            print(f"Exception: {e}")  # Debugging line
            return Response({'error_message': str(e)}, status=400)

    return Response({'error_message': 'Invalid request'}, status=400)


@api_view(['POST'])
@csrf_exempt
def create_team_for_organization(request):
    if request.method == 'POST':
        owner_localId = request.data.get('owner_localId')
        manager_localId = request.data.get('manager_localId')
        team_name = request.data.get('team_name')
        game = request.data.get('game')

        try:
            # Fetch all organizations to find the one owned by owner_localId
            all_orgs = database.child('organizations').get().val()
            print(f"All organizations: {all_orgs}")  # Debugging line

            org_data = None
            for org in all_orgs.values():
                print(f"Checking org: {org}")  # Debugging line
                if org['owner']['localId'] == owner_localId:
                    org_data = org
                    break

            if not org_data:
                return Response({'error_message': 'Invalid organization owner ID'}, status=400)
# Check if the organization already has a team for the given game
            existing_teams = org_data.get('teams', {})
            if game in existing_teams:
                return Response({'error_message': 'A team for this game already exists'}, status=400)

            # Check if the organization has reached the maximum number of teams (6)
            if len(existing_teams) >= 6:
                return Response({'error_message': 'Maximum number of teams reached'}, status=400)

            # Fetch the manager's data from the organization's members
            manager_data = org_data['members'].get(manager_localId)
            if not manager_data:
                return Response({'error_message': 'Invalid manager ID'}, status=400)

            # Create the team data
            team_data = {
                'owner_id': owner_localId,
                'org_name': org_data['org_name'],  # Include the organization name in the team data
                'manager_id': manager_localId,
                'manager_username': manager_data['username'],
                'manager_firstname': manager_data['firstname'],
                'manager_lastname': manager_data['lastname'],
                'team_name': team_name,
                'members': [],
                'pending_requests': [],
                'captain_id': None,
                'game': game
            }

            # Save the team data in the database
            team_ref = database.child('teams').child(game).push(team_data)

            # Update the organization's data to include the new team
            existing_teams[game] = team_ref.get('name')  # Retrieve the key using 'name' attribute
            database.child('organizations').child(owner_localId).update({'teams': existing_teams})

            # Update the manager's data to set 'is_manager' to True
            database.child('users').child(manager_localId).update({'is_manager': True})

            return Response({'message': 'Team created successfully.'})
        

        except Exception as e:
            return Response({'error_message': str(e)}, status=400)

    return Response({'error_message': 'Invalid request'}, status=400)



@api_view(['POST'])
@csrf_exempt
def create_event(request):
    if request.method == 'POST':
        localId = request.data.get('localId')
        event_name = request.data.get('event_name')
        selected_game = request.data.get('selected_game')
        event_description = request.data.get('event_description')
        rules = request.data.get('rules')
        prizes = request.data.get('prizes')
        maximum_teams = request.data.get('maximum_teams')
        event_date = request.data.get('event_date')  # this should be passed as a string in ISO format
        event_time = request.data.get('event_time')  # this should be passed as a string in 24h format

        # Check if the user is an organizer
        user = database.child('users').child(localId).get().val()

        try:
            # Get the organization details of the user
            org_id = next(iter(user.get('organizations', {})), None)
            if not org_id:
                return Response({'error_message': 'User is not part of any organization'}, status=400)

            org_details = database.child('organizations').child(org_id).get().val()
            if not org_details:
                return Response({'error_message': 'Invalid organization ID'}, status=400)

            org_name = org_details.get('org_name', '')
            username = user.get('username', '')

            # Create the event with the provided data and organization details
            data = {
                'event_name': event_name,
                'selected_game': selected_game,
                'event_description': event_description,
                'rules': rules,
                'prizes': prizes,
                'maximum_teams': maximum_teams,
                'event_date': event_date,
                'event_time': event_time,
                'organization_name': org_name,
                'creator_username': username,  # Include the username of the event creator
            }

            # First push the event to get a unique ID
            event = database.child('events').child(selected_game).push(data)

            # Add the event_id to the event data
            event_id = event['name']
            data['event_id'] = event_id

            # Save the event data again, now with the event_id included
            database.child('events').child(selected_game).child(event_id).set(data)

            # Return a success response
            return Response({'message': 'Event creation successful'})
        except Exception as e:
            # Handle event creation errors and return an appropriate response
            error_message = str(e)
            return Response({'error_message': error_message}, status=400)

    return Response({'error_message': 'Invalid request'}, status=400)

@api_view(['GET'])
@csrf_exempt
def get_all_events(request):
    if request.method == 'GET':
        try:
            # Retrieve all events from Firebase
            all_events = database.child('events').get().val()

            if all_events:
                # Prepare the list of events
                event_list = []
                for game, events in all_events.items():
                    for event_id, event_data in events.items():
                        # Add the event_id and the selected_game to the event data
                        event_data['event_id'] = event_id
                        event_data['selected_game'] = game
                        event_list.append(event_data)

                return Response(event_list)
            else:
                return Response({'error_message': 'No events found'}, status=400)

        except Exception as e:
            return Response({'error_message': str(e)}, status=400)

    return Response({'error_message': 'Invalid request'}, status=400)

