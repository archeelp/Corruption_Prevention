from flask_wtf import FlaskForm
from flask_wtf.file import FileField,FileAllowed
from wtforms import StringField, PasswordField, SubmitField, BooleanField,SelectField
from wtforms.fields.html5 import EmailField

from flask_login import current_user
from wtforms.validators import DataRequired, Length, Email, EqualTo ,  ValidationError
from models import Org


class LoginForm(FlaskForm):
    email = EmailField('Email address:', validators=[DataRequired(), Email()])
    password = PasswordField('Password:', validators=[DataRequired()])
    remember = BooleanField('Remember Me?')      
    submit = SubmitField('Login')

class RegistrationForm(FlaskForm):
    name = StringField('Name', validators=[DataRequired()])
    email = EmailField('Email address', validators=[DataRequired(), Email()])
    password = PasswordField('Password', validators=[DataRequired()])
    confirm_password = PasswordField('Confirm Password',
                                     validators=[EqualTo('password')])
    tender=StringField('tender')
    utype = StringField('utype',validators=[DataRequired()])
    
    submit = SubmitField('Sign Up')
   

