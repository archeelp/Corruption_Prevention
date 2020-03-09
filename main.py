from flask_login import login_user, current_user, logout_user, login_required
from werkzeug.utils import secure_filename
import re
from twilio.rest import Client
import os
import secrets
from PIL import Image
from flask import Flask,session, render_template, url_for,flash,redirect,request
import json
from init import app, db , bcrypt,mail
import os
from sqlalchemy.orm import Session
from flask_bcrypt import (Bcrypt,check_password_hash,generate_password_hash,)
from forms import RegistrationForm,LoginForm
from models import Org
from flask_login import login_user, current_user, logout_user, login_required
from flask_mail import Message
import requests




account_sid = 'AC9c7167abcd45b4773516a6b06303c596'
auth_token = '8f616ec6a5a58e3938592cf86db1a68b'
client_list = []
user = {}
def send_email(user,msgg):
    msg = Message('Public Key for logging in',
                  sender='noreply@demo.com',
                  recipients=[user['email']])
    msg.body = msgg['public_key']
    mail.send(msg)

def regex_match(string_to_search, term):
    try:
        result = re.search(term, string_to_search)
        if result:
            return result.group()
    except Exception:
        print('error occurred',Exception.with_traceback())
        return None

def extract(image_file):
    

    try:
        # Converts an uploaded image in common formats such as JPEG, PNG into text via Optical Character Recognition.
        api_response = api_instance.image_ocr_post(image_file)
        print(api_response)
        res = api_response.text_result
        aadhar_regex = r'\d{4}\s\d{4}\s\d{4}'
        aadhar = regex_match(res,aadhar_regex)
        print(aadhar)
        return aadhar
    except ApiException as e:
        print("Exception when calling ImageOcrApi->image_ocr_post: %s\n" % e)

def start_verification(phone,channel='sms'):
    print("Verification started")
    if channel not in ('sms', 'voice'):
        channel = 'sms'
    service = app.config.get("VERIFICATION_SID")
    print(service)
    verification = client_list[0].verify \
        .services(service) \
        .verifications \
        .create(to='+91'+phone, channel=channel)
    return verification.sid

def check_verification(phone, code):
    print("Verification checking started")
    service = app.config.get("VERIFICATION_SID")
    try:
        verification_check = client_list[0].verify \
            .services(service) \
            .verification_checks \
            .create(to='+91'+phone, code=code)
        return verification_check.status
    except Exception as e:
        flash("Error validating code: {}".format(e))

    return render_template('success.html')

@app.route('/visualise')
def visualise():
    response=requests.get('http://d4cca03c.ngrok.io/get_chain')
    print(response.json())
    return render_template('blocks.html',blockchain=response.json()['chain'])


@app.route('/send_file', methods=['GET', 'POST'])
def send_file():
    if request.method == 'POST':
        f = request.files['file']
        basepath = os.path.dirname(__file__)
        file_path = os.path.join('uploads', secure_filename(f.filename))
        print(file_path)
        print(type(file_path))
        f.save(file_path)
        aadhar = extract(file_path)
        email=request.form['email']
        fname = request.form['fname']
        lname = request.form['lname']
        phone = request.form['phonenumber']
        occupation = request.form['occupation']
        city = request.form['city']
        state = request.form['state']
        income = request.form['income']
        ration_card=request.form['ration_card']
       
      
        # client = Client(account_sid,auth_token)
        # client_list.append(client)
        # print(client)
        # print(type(client))
        session['phone'] = phone
        # vsid = start_verification(phone,channel='sms')
        if True:
            user['first_name'] = fname
            user['last_name'] = lname
            user['phone_number'] = phone
            user['aadhar_number'] = aadhar
            user['occupation'] = occupation
            user['city'] = city
            user['state'] = state
            user['income'] = income
            user['ration_card']=ration_card
            user['email'] = email
           
            return render_template('recieve_otp.html') 
    return redirect('/')


@app.route('/recieve_otp',methods=['GET','POST'])
def recieve_otp():
    global user
    print(user)
    if request.method == 'POST':
        phone = session.get('phone')
        code = request.form['code']
        # check = check_verification(phone, code)
        # client_list.pop(0)
        if True:
            url = 'http://d4cca03c.ngrok.io/add_to_pending_registration'
            response = requests.post(url,json= user)
            print(response)
            print(type(response))
            res = response.json()
            print(res)
            send_email(user,res)
            print(type(res))
            return render_template('success.html')
        else:
            return render_template('choose.html')
    return render_template('recieve_otp.html')

@app.route('/')
def home():
    return render_template('layout.html')

@app.route('/aboutus')
def aboutus():
    return render_template('success.html')


@app.route('/viewtenders')
def viewtenders():
    return render_template('success.html')

@app.route('/government_portal')
def government_portal():
    return render_template('government_portal.html')


@app.route('/userregister')
def userregister():
    return render_template('user.html')

@app.route("/glogin", methods=['GET', 'POST'])
def glogin():
    form = LoginForm()
    if form.validate_on_submit():
        org =Org.query.filter_by(email=form.email.data,password=form.password.data).first()
        if org:
            login_user(org, remember=form.remember.data)
            next_page = request.args.get('next')
            return redirect(next_page) if next_page else redirect('/government_portal')
        else:
            flash('Login Unsuccessful. Please check email and password')
            return redirect(url_for('/'))
    return render_template('login.html', title='Login', form=form)


@app.route("/gregister", methods=['GET', 'POST'])
def gregister():
    form = RegistrationForm()
    if form.validate_on_submit():
        
        org= Org(name=form.name.data,email=form.email.data,password=form.password.data,utype=form.utype.data)
        print(org)
        db.session.add(org)
        db.session.commit()
        flash('You were successfully signed up')
        return redirect('/')
        
    return render_template('register.html', title='register', form=form)


@app.route("/glogout")
def glogout():
    logout_user()
    return render_template('logout.html')

@app.route("/bidding")
def bidding():
    tenders=Org.query.all()
    return render_template('all_bidders.html',tenders=tenders)

@app.route("/view_bidding",methods=['POST'])
def view_bidding():
    amount=request.form.get('amount')
    print(amount)
    return render_template('success.html')



@app.route('/tender', methods=['GET','POST'])
def tender():
    if request.method=='POST':
        tender = request.form.get('tender')
        current_user.tender=tender
        # db.session.add(current_user)
        db.session.commit()
        flash('Your tender has been created! ','success')
        return redirect(url_for('aboutus'))
    return render_template('tender.html')


@app.route('/all_tenders', methods=['GET'])
def all_tenders():
    tenders=Org.query.all()
    return render_template('all_tenders.html',tenders=tenders)