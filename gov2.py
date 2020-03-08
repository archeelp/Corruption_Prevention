@app.route('/state_to_city',methods=["GET"])
def government_portal():
    return render_template("state_to_city.html")

@app.route('/post_route_city',methods=["POST"])
def post_route():
    amount=request.form.get('amount')
    state=request.form.get('from_state')
    city=request.form.get('to_city')
    return amount,state,city
