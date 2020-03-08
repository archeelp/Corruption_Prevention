from init import db,login_manager
from flask_login import UserMixin

@login_manager.user_loader
def load_user(org_id):
	return Org.query.get(int(org_id))


class Org(db.Model,UserMixin):
	__tablename__ = "org"
	id = db.Column(db.Integer, primary_key=True)
	name = db.Column(db.String(20), unique=True, nullable=False) 
	email = db.Column(db.String(120), unique=True, nullable=False)
	tender= db.Column(db.String(120), unique=True, nullable=True)
	password = db.Column(db.String(60), nullable=False)
	utype = db.Column(db.String(60),nullable=False)
	bid=db.Column(db.Integer, nullable = True)
	#image_file=db.Column(db.String(20),nullable=False,default='default.jpg')
	def __repr__(self):
		return f"Org('{self.name}', '{self.email}', '{self.password}')"   


# class Bid(db.Model,UserMixin):
    # __tablename__ = "bid"
	# bid = db.Column(db.Integer, primary_key=True)
	# username = db.Column(db.String(20), unique=True, nullable=False) 
	# email = db.Column(db.String(120), unique=True, nullable=False)
	# password = db.Column(db.String(60), nullable=False)
	# #image_file=db.Column(db.String(20),nullable=False,default='default.jpg')
	# def __repr__(self):
	# 	return f"Bid('{self.username}', '{self.email}', '{self.password}')"   
