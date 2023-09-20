from django.contrib import admin
from django.urls import path
from django.contrib.auth import views as auth_views
from fireapp import views


urlpatterns = [
    path('admin/', admin.site.urls),
    path('register/', views.register, name='register'),
    path('login/', views.login, name='login'),
    path('all_users/', views.get_all_users, name='get_all_users'),
    path('current_user/', views.current_user, name='current_user'),
    path('create_team/', views.create_team, name='create_team'),
    path('join_team/', views.join_team, name='join_team'),
    path('respond_to_request/', views.respond_to_request, name='respond_to_request'),
    path('get_all_teams/', views.get_all_teams, name='get_all_teams'),
    path('get_team_info/<str:manager_id>/', views.get_team_info, name='get_team_info'), 
    path('get_team_info_member/<str:localId>/', views.get_team_info_member, name='get_team_info_member'),
    path('create_scrim/', views.create_scrim, name='create_scrim'),
    path('get_scrim_details/<str:game>/<str:scrim_id>/', views.get_scrim_details, name='get_scrim_details'),
    path('get_all_scrims/<str:game>/', views.get_all_scrims, name='get_all_scrims'),
    path('request_scrim/', views.request_scrim, name='request_scrim'),  # new endpoint
    path('create_organization/', views.create_organization, name='create_organization'),
    path('approve_organization/', views.approve_organization, name='approve_organization'),
    path('all_organizations/', views.get_all_organizations, name='get_all_organizations'),
    path('approve_member/', views.approve_member, name='approve_member'),
    path('join_organization/', views.join_organization, name='join_organization'),
    path('create_team_for_organization/', views.create_team_for_organization, name='create_team_for_organization'),
    path('create_event/', views.create_event, name='create_event'),
    path('get_all_events/', views.get_all_events, name='get_all_events'),
    path('get_scrim_requests/<str:manager_id>/', views.get_scrim_requests, name='get_scrim_requests'),
    path('accept_scrim/', views.accept_scrim, name='accept_scrim'),
    path('get_all_pending_approvals/', views.get_all_pending_approvals, name='get_all_pending_approvals'),
]
