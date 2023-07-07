from django.contrib import admin
from django.urls import path
from django.contrib.auth import views as auth_views
from fireapp import views


urlpatterns = [
    path('admin/', admin.site.urls),
    path('register/', views.register, name='register'),
    path('login/', views.login, name='login'),
    path('user/<str:username>/', views.get_username, name='get_username'),
    path('logout/', views.logout, name='logout'),
    path('delete_account/', views.delete_account, name='delete_account'),


]

