with APQ.ODBC.Client;
with Ada.Text_IO;
use  APQ.ODBC.Client;
use  APQ;

procedure test is
	Connection : ODBC_Connection_Type;
begin
	Set_Host_Name(Connection, "sql_server_test_database");
	Set_User(Connection, "sa");
	Set_Password(Connection, "123");
	Connect(Connection);
end test;
