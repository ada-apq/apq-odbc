with APQ.ODBC.Client;
with Ada.Text_IO;
use  APQ.ODBC.Client;
use  APQ;

procedure test is
	Connection	: ODBC_Connection_Type;
	Query		: ODBC_Query_Type;
begin

	Set_Host_Name(Connection, "sql_server_test_database");
	Set_User(Connection, "sa");
	Set_Password(Connection, "123");
	Connect(Connection);
	if Is_Connected(Connection) then
		Ada.Text_IO.Put_Line("Everything Ok!");

		Append(Query, "INSERT INTO Users(Name) VALUES('Funcionou')");
		Execute(Query, Connection);
	end if;
end test;
