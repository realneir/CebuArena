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
    "apiKey": "AIzaSyDw9O_eTCyy-Poxm9OeatzVqeYDUFZAzDo",
    "authDomain": "tests-c91d0.firebaseapp.com",
     "databaseURL": "https://tests-c91d0-default-rtdb.firebaseio.com/",
    "projectId": "tests-c91d0",
    "storageBucket": "tests-c91d0.appspot.com",
    "messagingSenderId": "252862784800",
    "appId": "1:252862784800:web:b7de3c3653933bf39c6345",
    "measurementId": "G-FXCE602VES"
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
        username = None  # Initialize the username variable

        for user in users.each():
            if user.val()['email'] == email_from_request:  # Use the new variable here
                firstname = user.val().get('firstname', '')
                lastname = user.val().get('lastname', '')
                is_manager = user.val().get('is_manager', False)
                username = user.val().get('username', '')  # Get the username from the database
                local_id = user.key()
                break

        if email_from_request is None:
            return Response({'error_message': 'Invalid email'}, status=status.HTTP_400_BAD_REQUEST)

        password = request.data.get('password')

        try:
            # Perform the login process
            user = authe.sign_in_with_email_and_password(email_from_request, password)

            # Return the username, localId, firstname, lastname, and is_manager along with the success response
            return Response({
                'message': 'Login successful',
                'email': email_from_request,
                'localId': local_id,
                'firstname': firstname,
                'lastname': lastname,
                'username': username,  # Include the username in the response
                'is_manager': is_manager
            })
        except Exception as e:
            # Handle login errors and return an appropriate response
            error_message = str(e)
            return Response({'error_message': error_message}, status=status.HTTP_400_BAD_REQUEST)

    return Response({'error_message': 'Invalid request'}, status=status.HTTP_400_BAD_REQUEST)




@api_view(['GET'])
@csrf_exempt
def current_user(request):
    if request.method == 'GET':
        # Get the user's token from the request headers
        token = request.headers.get('Authorization')

        if not token:
            # Return an error response if the token is missing
            return Response({'error_message': 'Authorization header missing'}, status=401)

        try:
            # Verify the token and get user information
            user_info = authe.get_account_info(token)

            # Get user ID
            user_id = user_info['users'][0]['localId']

            # Fetch the user's data from the database
            user_data = database.child('users').child(user_id).get().val()

            # If the user data is None, it means the user doesn't exist in the database
            if not user_data:
                return Response({'error_message': 'User not found in the database'}, status=404)

            # Get the firstname and lastname
            firstname = user_data.get('firstname', '')
            lastname = user_data.get('lastname', '')

            # Return the firstname and lastname
            return Response({'firstname': firstname, 'lastname': lastname})
        except Exception as e:
            # Handle errors and return an appropriate response
            error_message = str(e)
            return Response({'error_message': error_message}, status=400)

    return Response({'error_message': 'Invalid request'}, status=400)






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

            team_ref = database.child('teams').push(data)

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

            team_data = database.child('teams').child(team_id).get().val()
            if not team_data:
                return Response({'error_message': 'Invalid team_id'}, status=400)

            # Retrieve the username and email from the user data
            username = user_data.get('username')
            email = user_data.get('email')

            # Add the player's username and email to the pending_requests list
            pending_requests = team_data.get('pending_requests', [])
            pending_requests.append({'team_id': team_id, 'localId': localId, 'username': username, 'email': email})

            # Update the pending_requests field
            pending_requests_path = team_id + '/pending_requests'
            database.child('teams').child(pending_requests_path).set(pending_requests)

            return Response({'message': 'Request sent successfully.'})
        except Exception as e:
            return Response({'error_message': str(e)}, status=400)

    return Response({'error_message': 'Invalid request'}, status=400)


@api_view(['POST'])
@csrf_exempt
def respond_to_request(request):
    if request.method == 'POST':
        team_id = request.data.get('team_id')
        localId = request.data.get('localId')
        accept = request.data.get('accept')  # This should be a boolean
        manager_id = request.data.get('manager_id')  # This should be the id of the manager making the request

        try:
            team_data = database.child('teams').child(team_id).get().val()
            if not team_data:
                return Response({'error_message': 'Invalid team_id'}, status=400)

            # Check if the user making the request is the manager of the team
            if team_data['manager_id'] != manager_id:
                return Response({'error_message': 'Only the manager can accept or reject requests.'}, status=403)

            # Get the pending_requests list
            pending_requests = team_data.get('pending_requests', [])
            
            if accept:
                # Find the index of the request corresponding to the localId
                request_index = None
                for i, request in enumerate(pending_requests):
                    if request.get('localId') == localId:
                        request_index = i
                        break

                # Remove the player's id from the pending_requests list if it is accepted
                if request_index is not None:
                    pending_requests.pop(request_index)

                    # Update the pending_requests field with the modified list
                    pending_requests_path = team_id + '/pending_requests'
                    database.child('teams').child(pending_requests_path).set(pending_requests)

                    # Get the player's details
                    player_data = database.child('users').child(localId).get().val()
                    print(player_data)
                    if not player_data:
                        return Response({'error_message': 'Invalid localId'}, status=400)

                    player_details = {
                        'username': player_data.get('username'),
                        'firstname': player_data.get('firstname'),
                        'lastname': player_data.get('lastname'),
                        'id': localId
                    }

                    # Add the player to the members list
                    members = team_data.get('members', [])
                    members.append(player_details)

                    # Update the members field
                    members_path = team_id + '/members'
                    database.child('teams').child(members_path).set(members)

                else:
                    return Response({'error_message': 'Invalid localId'}, status=400)

            return Response({'message': 'Request processed successfully.'})
        except Exception as e:
            return Response({'error_message': str(e)}, status=400)

    return Response({'error_message': 'Invalid request'}, status=400)




@api_view(['GET'])
def get_all_teams(request):
    if request.method == 'GET':
        try:
            teams_data = database.child('teams').get().val()
            if not teams_data:
                return Response({'error_message': 'No teams found'}, status=404)

            teams_list = []
            for team_id, team in teams_data.items():
                team_info = {
                    'team_id': team_id,  # This is the key of the team in the 'teams' node
                    'team_name': team.get('team_name'),
                    'manager': {
                        'username': team.get('manager_username'),
                        'firstname': team.get('manager_firstname'),
                        'lastname': team.get('manager_lastname')
                    },
                    'members': team.get('members'),
                    'game': team.get('game')
                }
                teams_list.append(team_info)
                print(team_info)

            return Response({'teams': teams_list}, status=200)
        except Exception as e:
            return Response({'error_message': str(e)}, status=400)

    return Response({'error_message': 'Invalid request'}, status=400)



# @api_view(['POST'])
# @csrf_exempt
# def join_team(request):
#     if request.method == 'POST':
#         user_id = request.data.get('user_id')
#         team_id = request.data.get('team_id')

#         try:
#             user_data = database.child('users').child(user_id).get().val()
#             if user_data:
#                 request_data = {
#                     'user_id': user_id,
#                     'username': user_data.get('username'),
#                     'firstname': user_data.get('firstname'),
#                     'lastname': user_data.get('lastname'),
#                 }
#             else:
#                 return Response({'error_message': 'Invalid user_id'}, status=400)
            
#             team_ref = database.child('teams').child(team_id)
#             current_requests = team_ref.child('pending_requests').get().val() or []

#             # Prevent duplicate requests
#             if any(req['user_id'] == user_id for req in current_requests):
#                 return Response({'error_message': 'Request already sent'}, status=400)

#             current_requests.append(request_data)
#             team_ref.update({'pending_requests': current_requests})

#             return Response({'message': 'Request to join team sent successfully.'})
#         except Exception as e:
#             return Response({'error_message': str(e)}, status=400)

#     return Response({'error_message': 'Invalid request'}, status=400)


# @api_view(['POST'])
# @csrf_exempt
# def manage_team_request(request):
#     if request.method == 'POST':
#         user_id = request.data.get('user_id')
#         team_id = request.data.get('team_id')
#         action = request.data.get('action')  # 'accept' or 'decline'

#         try:
#             team_ref = database.child('teams').child(team_id)
#             current_requests = team_ref.child('pending_requests').get().val() or []
#             current_members = team_ref.child('members').get().val() or []

#             # Find the request to be managed
#             for i, req in enumerate(current_requests):
#                 if req['user_id'] == user_id:
#                     if action == 'accept':
#                         current_members.append(req)
#                     current_requests.pop(i)
#                     break
#             else:
#                 return Response({'error_message': 'No pending request from this user'}, status=400)

#             # Update the team's members and pending_requests
#             team_ref.update({'members': current_members, 'pending_requests': current_requests})

#             return Response({'message': f'Request to join team has been {action}ed.'})
#         except Exception as e:
#             return Response({'error_message': str(e)}, status=400)

#     return Response({'error_message': 'Invalid request'}, status=400)


@api_view(['GET'])
@csrf_exempt
def get_team_info(request, manager_id):
    if request.method == 'GET':
        try:
            # Retrieve all the team data from Firebase
            all_teams = database.child('teams').get().val()
            
            if all_teams:
                # Find the team that has the given manager_id
                for team_id, team_info in all_teams.items():
                    if team_info.get('manager_id') == manager_id:
                        return Response(team_info)
                
                # If no team is found with the given manager_id
                return Response({'error_message': 'No team found for the given manager_id'}, status=400)
            
            else:
                return Response({'error_message': 'No teams found'}, status=400)

        except Exception as e:
            return Response({'error_message': str(e)}, status=400)

    return Response({'error_message': 'Invalid request'}, status=400)

@api_view(['POST'])
def create_scrim(request):
    if request.method == 'POST':
        
        manager_id = request.data.get('manager_id')  
        # team_name = request.data.get('team_name')  # <-- Add this line
        game = request.data.get('game')
        date = request.data.get('date')
        time = request.data.get('time')
        preferences = request.data.get('preferences')
        contact = request.data.get('contact')

        data = {
            'manager_id': manager_id,  
            # 'team_name': team_name,  # <-- Add this line
            'game' : game,
            'date': date,
            'time': time,
            'preferences': preferences,
            'contact': contact
        }

        try:
            new_scrim = database.child('scrims').child(game).push(data)
            scrim_id = new_scrim["name"]  
            data["scrim_id"] = scrim_id  

            return Response(data, status=201)
        except Exception as e:
            return Response({'error_message': str(e)}, status=500)

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
                if team:
                    # Include the team_name in the scrim details
                    scrim['team_name'] = team.get('teamName')
                else:
                    # If team is not found, set team_name to None or any other default value
                    scrim['team_name'] = 'Team Not Found'

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
                    result_scrims.append({scrim_id: scrim_data})

                return Response(result_scrims)
            else:
                return Response({'error_message': 'No scrims found for the given game'}, status=400)

        except Exception as e:
            return Response({'error_message': str(e)}, status=400)

    return Response({'error_message': 'Invalid request'}, status=400)







