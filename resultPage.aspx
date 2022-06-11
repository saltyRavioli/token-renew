<%@ Page Language="VB" Debug="true" aspcompat=true %>

<%
'Dim OpenFileobj, FSOobj,FilePath
 'FSOobj = Server.CreateObject("Scripting.FileSystemObject")

 'OpenFileobj = FSOobj.OpenTextFile("C:\inetpub\wwwroot\Renew\c.txt",2)
'OpenFileobj.Write("my data here")
'OpenFileobj.WriteLine(" Welcome to Plus2net.com ")
'OpenFileobj.Write("Learn ASP- VBScript the programming language ")
'OpenFileobj.WriteBlankLines(4)
'OpenFileobj.WriteLine("You can develop interactive web pages ")
'OpenFileobj.Write("Thank you & Visit again")
'OpenFileobj.Close
 'OpenFileobj = Nothing
%>
<%
  'dim connectionString = "PROVIDER=SQLOLEDB;Data Source=MVITDCTX01Q\SQLEXPRESS;Database=TokenRenewal;Integrated Security=SSPI;"
  dim connectionString = "PROVIDER=MSOLEDBSQL;Data Source=MVITDCTX01Q\SQLEXPRESS;Database=TokenRenewal;Trusted_Connection=yes;"
  dim connect = Server.createObject("ADODB.Connection")
  connect.open(connectionString)

  dim userID = Replace(Request.form("userID"), "'", "''")
  dim firstName = Replace(Request.form("FirstName"), "'", "''")
  dim lastName = Replace(Request.form("LastName"), "'", "''")
  dim costCentre = Replace(Request.form("CostCentre"), "'", "''")
  dim fac = Replace(Request.form("FAC"), "'", "''")
  dim managerName = Replace(Request.form("ManagerName"), "'", "''")
  dim tokenType = Replace(Request.form("tokentype"), "'", "''")
  dim tokenChoice
  If tokenType = "Hardware Token" Then
    tokenChoice = Replace(Request.form("pickuplocation"), "'", "''")  'idk what the id is for this anymore
  Else
    tokenChoice = Replace(Request.form("phonetype"), "'", "''")
  End If


  dim sSQL
  sSQL = "Insert Into SubmittedTokens (UserID, FirstName, LastName,TokenType,TokenTypePick,CostCentre,FAC,ManagerName) Values('"
  sSQL = sSQL + userID +"','"
  sSQL = sSQL + firstName +"','"
  sSQL = sSQL + lastName +"','"
  sSQL = sSQL + tokenType +"','"
  sSQL = sSQL + tokenChoice +"','"
  sSQL = sSQL + costCentre +"','"
  sSQL = sSQL + fac +"','"
  sSQL = sSQL + managerName + "')"
  connect.Execute(sSQL)
%>

<!DOCTYPE html>
<html style="font-size: 16px;">
  <head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta charset="utf-8">
    <meta name="keywords" content="">
    <meta name="description" content="">
    <meta name="page_type" content="np-template-header-footer-from-plugin">
    <title>resultPage</title>
    <link rel="stylesheet" href="nicepage.css" media="screen">
<link rel="stylesheet" href="resultPage.css" media="screen">
    <script class="u-script" type="text/javascript" src="jquery.js" defer=""></script>
    <script class="u-script" type="text/javascript" src="nicepage.js" defer=""></script>
    <meta name="generator" content="Nicepage 3.23.2, nicepage.com">
    <link id="u-theme-google-font" rel="stylesheet" href="https://fonts.googleapis.com/css?family=Roboto:100,100i,300,300i,400,400i,500,500i,700,700i,900,900i|Open+Sans:300,300i,400,400i,600,600i,700,700i,800,800i">
    
    
    <script type="application/ld+json">{
		"@context": "http://schema.org",
		"@type": "Organization",
		"name": "Token Renew v1",
		"logo": "images/logowhiteHorizon2.svg"
}</script>
    <meta name="theme-color" content="#478ac9">
    <meta property="og:title" content="resultPage">
    <meta property="og:description" content="">
    <meta property="og:type" content="website">
  </head>
  <body class="u-body"><header class="u-align-center u-clearfix u-header u-palette-1-dark-2 u-header" id="sec-2b2d"><div class="u-clearfix u-sheet u-sheet-1">
        <a href="#" class="u-image u-logo u-image-1">
          <img src="images/logowhiteHorizon2.svg" class="u-logo-image u-logo-image-1" data-image-width="187">
        </a>
        <h1 class="u-custom-font u-font-georgia u-text u-text-default-lg u-text-default-md u-text-default-sm u-text-default-xl u-title u-text-1">June 2020 RSA Token Renew Form</h1>
      </div></header>
    <section class="u-align-left u-clearfix u-image u-section-1" id="sec-a558" data-image-width="150" data-image-height="100">
      <p class="u-custom-font u-font-georgia u-text u-text-palette-5-dark-2 u-text-1"><b>Your Token Renewal Information Submitted Successfully,
          <%
              response.write(request.form("FirstName"))
              response.write(" ")
              response.write(request.form("LastName"))
          %>
      </b>
        <br><b>Your Confirmation ID :
              <%
                  dim query = Server.CreateObject("ADODB.Recordset")

                  dim queryString = "Select Max(ID) maxID from SubmittedTokens"
                  queryString = queryString + " Where UserID = '" + userID + "'"
                  queryString = queryString + " and FirstName = '" + firstName + "'"
                  queryString = queryString + " and LastName = '" + lastName + "'"

                  query.Open(queryString, connect)

                  response.write(query.Fields.Item("maxID").value)
              %>
        </b>
      </p>
    </section>
    
    
    <footer class="u-align-left u-clearfix u-footer u-palette-1-dark-2 u-footer" id="sec-9d49"><div class="u-clearfix u-sheet u-sheet-1"></div></footer>
  </body>
</html>