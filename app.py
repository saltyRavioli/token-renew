from asyncio.windows_events import NULL
from tokenize import String
from flask import Flask, request, send_file, render_template
import datetime
import pyodbc

# import sqlite3
# from sqlite3 import Error

app = Flask(__name__)
#sqlite things
# def create_connection(db_file): #initialize connection to database (also creates database if doesn't exist)
#     conn = None
#     try:
#         conn = sqlite3.connect(db_file)
#         print(sqlite3.version)
#     except Error as e:
#         print(e)
#     return conn
# def create_table(conn, create_table_sql): #code for creating table
#     try:
#         c = conn.cursor()
#         c.execute(create_table_sql)
#     except Error as e:
#         print(e)
# def token_table(): #makes sure the token table is created
#     database = r"tableDatabase.db"
#     createTableStatement = """ CREATE TABLE IF NOT EXISTS SubmittedTokens (
#                                         id integer PRIMARY KEY,
#                                         date text NOT NULL,
#                                         UserID text NOT NULL,
#                                         ManagerName text NOT NULL,
#                                         FirstName text NOT NULL,
#                                         LastName text NOT NULL,
#                                         CostCentre text NOT NULL,
#                                         FAC text NOT NULL,
#                                         PhoneType text NOT NULL,
#                                         TokenType text NOT NULL,
#                                         PickupLocation text NOT NULL,
#                                     ); """
#     conn = create_connection(database)
#     if conn is not None:
#         create_table(conn, createTableStatement)
#     else:
#         print("Error! cannot create the database connection.")
# def input_data(conn, project):
#     sql = ''' (UserID, ManagerName, FirstName, LastName, TokenType, TokenTypePick, CostCentre, FAC)
#               VALUES(?,?,?) '''
#     cur = conn.cursor()
#     cur.execute(sql, project)
#     conn.commit()
#     return cur.lastrowid

conn = pyodbc.connect(r'''Driver={SQL Server};
                        Server=IPAD\SQLEXPRESS;
                        PORT=1433;
                        Database=TokenRenewal;
                        Trusted_Connection=yes;
                        UID=IPAD\natha;''')

cursor = conn.cursor()
# def create_table():
#     statement = """ CREATE TABLE IF NOT EXISTS SubmittedTokens (
#                                         id int PRIMARY KEY NOT NULL IDENTITY(1,1),
#                                         date text NOT NULL,
#                                         UserID text NOT NULL,
#                                         ManagerName text NOT NULL,
#                                         FirstName text NOT NULL,
#                                         LastName text NOT NULL,
#                                         CostCentre text NOT NULL,
#                                         FAC text NOT NULL,
#                                         TokenType text NOT NULL,
#                                         PhoneOrPickup text,
#                                     ); """
#     cursor.execute(statement)
#     conn.commit()
def input_data(values):
    statement = 'INSERT INTO SubmittedTokens (date, UserID, ManagerName, FirstName, LastName, CostCentre, FAC, TokenType, PhoneOrPickup) VALUES '
    statement += values
    statement2 = ' SELECT TOP 1 [id], [FirstName], [LastName] FROM SubmittedTokens ORDER BY [id] DESC;' #in retrospect, don't think i need firstname/lastname
    cursor.execute(statement)
    cursor.execute(statement2)
    id = cursor.fetchone()[0] 
    conn.commit()
    return id


@app.route('/')
def index():
    return send_file('index.html')

@app.route('/resultPage', methods=['POST'])
def resultPage():
    # create_table() #this is a terrible idea but ¯\_(ツ)_/¯ ... ok this doesn't even work 
    #(date, UserID, ManagerName, FirstName, LastName, CostCentre, FAC, TokenType, PhoneOrPickup)
    values = "('"+datetime.datetime.now().strftime("%m/%d/%Y, %H:%M:%S") + "',"
    values += "'"+request.form['UserID']+"',"
    values += "'"+request.form['ManagerName']+"',"
    values += "'"+request.form['FirstName']+"',"
    values += "'"+request.form['LastName']+"',"
    values += "'"+request.form['CostCentre']+"',"
    values += "'"+request.form['FAC']+"',"
    values += "'"+request.form['TokenType']+"',"

    tokenChoice = NULL
    if request.form['TokenType'] == "Hardware Token":
        tokenChoice = request.form["PickupLocation"]
    else:
        tokenChoice = request.form["PhoneType"]
    values += "'"+tokenChoice+"')"

    id = input_data(values)
    return render_template('resultPage.html', entryID = id, firstName = request.form['FirstName'], lastName = request.form['LastName'])

if __name__ == '__main__':
    # create_table()
    app.run()