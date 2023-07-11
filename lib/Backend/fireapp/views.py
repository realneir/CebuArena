from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework import status
from django.views.decorators.csrf import csrf_exempt
import pyrebase

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
        username = request.data.get('username')
        
        # Fetch the email, firstname, and lastname associated with this username from the database
        users = database.child('users').get()
        email = None
        firstname = None
        lastname = None
        local_id = None

        for user in users.each():
            if user.val()['username'] == username:
                email = user.val()['email']
                firstname = user.val().get('firstname', '')
                lastname = user.val().get('lastname', '')
                local_id = user.key()
                break
                
        if email is None:
            return Response({'error_message': 'Invalid username'}, status=status.HTTP_400_BAD_REQUEST)

        password = request.data.get('password')

        try:
            # Perform the login process
            user = authe.sign_in_with_email_and_password(email, password)

            # Return the username, localId, firstname, and lastname along with the success response
            return Response({
                'message': 'Login successful',
                'username': username,
                'localId': local_id,
                'firstname': firstname,
                'lastname': lastname
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
            # Retrieve the user data associated with the manager_id from Firebase
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
                'members': [
                    {
                        'username': username,
                        'firstname': firstname,
                        'lastname': lastname
                    }
                ],
                'captain_id': None,
                'game': game,
            }

            # Push the team data to the 'teams' collection in Firebase
            team_ref = database.child('teams').push(data)
            
            # Update the user's data to set 'role' to 'manager: true'
            user_ref = database.child('users').child(manager_id)
            user_ref.update({'role': {'manager': True}})

            return Response({'message': 'Team created successfully.'})
        except Exception as e:
            return Response({'error_message': str(e)}, status=400)

    return Response({'error_message': 'Invalid request'}, status=400)




# @api_view(['POST'])
# @csrf_exempt
# def logout(request):
#     if request.method == 'POST':
#         # Get the user's token from the request headers
#         token = request.headers.get('Authorization')

#         try:
#             # Perform the logout process
#             authe.current_user = None  # Set the current user to None
#             # Delete the user account using the token
#             authe.delete_account(token)

#             # Return a success response
#             return Response({'message': 'Logout and account deletion successful'})
#         except Exception as e:
#             # Handle logout and account deletion errors and return an appropriate response
#             error_message = str(e)
#             return Response({'error_message': error_message}, status=400)

#     return Response({'error_message': 'Invalid request'}, status=400)

# @api_view(['POST'])
# @csrf_exempt
# def delete_account(request):
#     if request.method == 'POST':
#         # Get the user's token from the request headers
#         token = request.headers.get('Authorization')

#         try:
#             # Delete the user account using the token
#             authe.delete_account(token)

#             # Return a success response
#             return Response({'message': 'Account deleted'})
#         except Exception as e:
#             # Handle account deletion errors and return an appropriate response
#             error_message = str(e)
#             return Response({'error_message': error_message}, status=400)

#     return Response({'error_message': 'Invalid request'}, status=400)
# #asd



