from flask import Flask, render_template , request
from flaskext.mysql import MySQL
from datetime import datetime

app = Flask(__name__)

mysql = MySQL()
app.config['MYSQL_DATABASE_HOST'] = 'localhost'
app.config['MYSQL_DATABASE_USER'] = 'root'
app.config['MYSQL_DATABASE_PASSWORD'] = ''
app.config['MYSQL_DATABASE_DB'] = 'desdecero'
mysql.init_app(app)



@app.route('/')
def mostrar():
    sql ="select * from registro"
    conn = mysql.connect()
    cursor=conn.cursor()
    cursor.execute(sql)
    miguel=cursor.fetchall()
    print(miguel)
    return render_template('index.html')
    


@app.route('/add', methods=['POST'])
def add():
    nombre = request.form['nombre']
    foto = request.files['foto']

    hora = datetime.now()
    tiempo=hora.strftime("%Y%H%M%S")

    if foto.filename!='':
        nuevofoto = tiempo+foto.filename
        foto.save("uploads/"+nuevofoto)

    sql = "INSERT INTO registro (nombre, foto) VALUES (%s, %s)"
    datos = (nombre , foto.filename)
    con = mysql.connect()
    cursor = con.cursor()
    cursor.execute(sql, datos)
    con.commit()
    return 'ok'



@app.route('/')
def hola():
    return render_template('index.html')


if __name__ == '__main__':
    app.run(debug=True, port=5000)




# @app.route('/add', methods=['POST'])
# def add():
#     nombre = request.form['nombre']
#     foto = request.files['foto'] 

#     hora = datetime.now()
#     tiempo=hora.strftime("%Y%H%M%S")

#     if foto.filename!='':
#         nuevofoto = tiempo+foto.filename
#         foto.save("uploads/"+nuevofoto)

#     cur = mysql.connection.cursor()
#     cur.execute("INSERT INTO registro (nombre, foto) VALUES (%s, %s)", (nombre, foto.filename))
#     mysql.connection.commit()
#     cur.close()
    
#     return 'ok'
