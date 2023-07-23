from django.contrib import admin
from django.urls import path
from django.contrib.auth import views as auth_views
from fireapp import views


urlpatterns = [
    path('admin/', admin.site.urls),
    path('register/', views.register, name='register'),
    path('login/', views.login, name='login'),
    #path('user/<str:username>/', views.get_username, name='get_username'),
    #path('logout/', views.logout, name='logout'),
    #path('delete_account/', views.delete_account, name='delete_account'),
    #path('get-username/', views.get_username, name='get_username'),
    path('all_users/', views.get_all_users, name='get_all_users'),
    path('current_user/', views.current_user, name='current_user'),
    path('create_team/', views.create_team, name='create_team'),
    path('join_team/', views.join_team, name='join_team'),
    path('respond_to_request/', views.respond_to_request, name='respond_to_request'),
    path('get_all_teams/', views.get_all_teams, name='get_all_teams'),
    path('get_team_info/<str:manager_id>/', views.get_team_info, name='get_team_info'), 
    path('create_scrim/', views.create_scrim, name='create_scrim'),
    path('get_scrim_details/<str:game>/<str:scrim_id>/', views.get_scrim_details, name='get_scrim_details'),
    path('get_all_scrims/<str:game>/', views.get_all_scrims, name='get_all_scrinms'),


    

    # path('get_teams_by_manager/<str:manager_id>/', views.get_teams_by_manager, name='get_teams_by_manager'),
]

