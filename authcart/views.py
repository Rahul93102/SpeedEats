from django.core.cache import cache
from django.shortcuts import render, redirect, HttpResponse
from django.contrib.auth.models import User
from django.views.generic import View
from django.contrib import messages
from django.template.loader import render_to_string
from django.utils.http import urlsafe_base64_decode, urlsafe_base64_encode
from .utils import TokenGenerator, generate_token
from django.utils.encoding import force_bytes  # Add this import
from django.core.cache import cache
import time
from django.contrib.auth.models import User
from django.shortcuts import render, redirect
from django.views.generic import View
from django.contrib import messages
from django.template.loader import render_to_string
from django.utils.http import urlsafe_base64_decode, urlsafe_base64_encode
from django.utils.encoding import force_bytes
from django.contrib.auth.tokens import PasswordResetTokenGenerator
from django.contrib.auth import authenticate, login, logout


from django.core.mail import EmailMessage
from django.conf import settings

from django.contrib.auth.tokens import PasswordResetTokenGenerator
from django.contrib.auth import authenticate, login, logout
# Create your views here.


# Create your views here.
def signup(request):
    if request.method=="POST":
        email=request.POST['email']
        password=request.POST['pass1']
        confirm_password=request.POST['pass2']
        if password!=confirm_password:
            messages.warning(request,"Password is Not Matching")
            return render(request,'signup.html')                   
        try:
            if User.objects.get(username=email):
                # return HttpResponse("email already exist")
                messages.info(request,"Email is Taken")
                return render(request,'signup.html')
        except Exception as identifier:
            pass
        user = User.objects.create_user(email,email,password)
        user.is_active=False
        user.save()
        email_subject="Activate Your Account"
        message=render_to_string('activate.html',{
            'user':user,
            'domain':'127.0.0.1:8000',
            'uid':urlsafe_base64_encode(force_bytes(user.pk)),
            'token':generate_token.make_token(user)

        })

        # email_message = EmailMessage(email_subject,message,settings.EMAIL_HOST_USER,[email])
        # email_message.send()
        messages.success(request,f"Activate Your Account by clicking the link in your gmail {message}")
        return redirect('/auth/login/')
    return render(request,"signup.html")


class ActivateAccountView(View):
    def get(self,request,uidb64,token):
        try:
            uid=str(urlsafe_base64_decode(uidb64))
            user=User.objects.get(pk=uid)
        except Exception as identifier:
            user=None
        if user is not None and generate_token.check_token(user,token):
            user.is_active=True
            user.save()
            messages.info(request,"Account Activated Successfully")
            return redirect('/auth/login')
        return render(request,'activatefail.html')

# def handlelogin(request):
#     if request.method=="POST":

#         username=request.POST['email']
#         userpassword=request.POST['pass1']
#         myuser=authenticate(username=username,password=userpassword)

#         if myuser is not None:
#             login(request,myuser)
#             messages.success(request,"Login Success")
#             return redirect('/')

#         else:
#             messages.error(request,"Invalid Credentials")
#             return redirect('/auth/login')

#     return render(request,'login.html')  






import time  # Import time module

BLOCK_THRESHOLD = 3  # Maximum allowed failed login attempts
BLOCK_TIME = 30  # Block duration in seconds

def handlelogin(request):
    if request.method == "POST":
        username = request.POST['email']
        userpassword = request.POST['pass1']

        # Check if the user is blocked
        blocked_key = f'blocked_user_{username}'
        blocked_time = cache.get(blocked_key)
        if blocked_time is not None:
            # User is blocked, calculate remaining block time
            remaining_time = BLOCK_TIME - (time.time() - blocked_time)
            if remaining_time > 0:
                # User is still blocked
                messages.error(request, f"Too many failed login attempts. Please try again in {remaining_time} seconds.")
                return redirect('/auth/login')

        myuser = authenticate(username=username, password=userpassword)
        if myuser is not None:
            login(request, myuser)
            messages.success(request, "Login Success")

            # Reset failed login attempts if login is successful
            cache.delete(blocked_key)
            return redirect('/')
        else:
            # Increment failed login attempts count
            failed_attempts_key = f'failed_attempts_{username}'
            failed_attempts = cache.get(failed_attempts_key, 0)
            failed_attempts += 1
            cache.set(failed_attempts_key, failed_attempts)

            # Check if user should be blocked
            if failed_attempts >= BLOCK_THRESHOLD:
                # Block user and set block time
                cache.set(blocked_key, time.time(), BLOCK_TIME)

            messages.error(request, "Invalid Credentials")
            return redirect('/auth/login')

    return render(request, 'login.html')



def handlelogout(request):
    logout(request)
    messages.info(request,"Logout Success")
    return redirect('/auth/login')



from django.core.cache import cache
import time

class RequestResetEmailView(View):
    def get(self,request):
        return render(request,'request-reset-email.html')
    
    def post(self,request):
        email=request.POST['email']
        user=User.objects.filter(email=email)

        # Check if the user has reached the maximum failed attempts
        failed_attempts_key = f'failed_reset_attempts_{email}'
        failed_attempts = cache.get(failed_attempts_key, 0)
        if failed_attempts >= 3:
            # User has reached the maximum failed attempts, check if they are still blocked
            blocked_key = f'blocked_reset_user_{email}'
            blocked_time = cache.get(blocked_key)
            if blocked_time is not None:
                # User is still blocked, calculate remaining block time
                remaining_time = 30 - (time.time() - blocked_time)
                if remaining_time > 0:
                    messages.error(request, f"Too many failed reset attempts. Please try again in {remaining_time} seconds.")
                    return redirect('/auth/login')

        if user.exists():
            # Send email and other logic...
            messages.info(request, "Email with reset instructions sent successfully.")
            cache.delete(failed_attempts_key)  # Reset failed attempts upon successful request
            return render(request,'request-reset-email.html')  # Return a rendered template or redirect here
        else:
            # Increment failed attempts count
            failed_attempts += 1
            cache.set(failed_attempts_key, failed_attempts)
            # Check if user should be blocked
            if failed_attempts >= 3:
                # Block user and set block time
                blocked_key = f'blocked_reset_user_{email}'
                cache.set(blocked_key, time.time())

            messages.error(request, "No user found with this email.")
            return render(request,'request-reset-email.html')  # Return a rendered template or redirect here



class SetNewPasswordView(View):
    def get(self, request, uidb64, token):
        context = {
            'uidb64': uidb64,
            'token': token
        }
        try:
            user_id = str(urlsafe_base64_decode(uidb64))
            user = User.objects.get(pk=user_id)
        except Exception as e:
            messages.warning(request, "Invalid user or token.")
            return redirect('/auth/login/')  # Redirect to login page or any other appropriate URL

        return render(request, 'set-new-password.html', context)

    def post(self, request, uidb64, token):
        context = {
            'uidb64': uidb64,
            'token': token
        }
        password = request.POST.get('pass1')
        confirm_password = request.POST.get('pass2')
        
        if password != confirm_password:
            messages.warning(request, "Passwords do not match.")
            return render(request, 'set-new-password.html', context)

        try:
            user_id = str(urlsafe_base64_decode(uidb64))
            user = User.objects.get(pk=user_id)
            user.set_password(password)
            user.save()
            messages.success(request, "Password reset successfully. Please login with your new password.")
            return redirect('/auth/login/')
        except Exception as e:
            messages.error(request, "Failed to reset password. Please try again later.")
            return render(request, 'set-new-password.html', context)



