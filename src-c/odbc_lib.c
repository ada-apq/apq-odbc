#include "odbc_lib.h"

int main(void) {

  char ercode[6];
  SQLINTEGER  err;
  char error[250];
  SQLSMALLINT size;
  SQLRETURN   return_Value;
  SQLSMALLINT columns;
  int row = 0;

  SQLHSTMT statement;

  ODBC_Facade* facade;
  facade = new_ODBC_Facade();

  login_Information_Set_Up(facade->login_Information, "sa", "123",
			   "sql_server_test_database");

  connect_With_Data_Source(facade);

  SQLAllocHandle(SQL_HANDLE_STMT, facade->connection_Handle, &statement);
  SQLExecDirect(statement, "SELECT * FROM USERS", 19);

  SQLNumResultCols(statement, &columns);
  while (SQL_SUCCEEDED(return_Value = SQLFetch(statement))) {
    SQLUSMALLINT i;
    printf("Row %d\n", row++);
    /* Loop through the columns */
    for (i = 1; i <= columns; i++) {
      SQLINTEGER indicator;
      char buf[512];
      /* retrieve column data as a string */
      return_Value = SQLGetData(statement, i, SQL_C_CHAR,
				buf, sizeof(buf), &indicator);
      if (SQL_SUCCEEDED(return_Value)) {
	/* Handle null columns */
	if (indicator == SQL_NULL_DATA) strcpy(buf, "NULL");
	printf("  Column %u : %s\n", i, buf);
      }
    }
  }

  SQLGetDiagRec(SQL_HANDLE_DBC, facade->environment_Handle, 1, ercode, &err,
		error, 250, &size);
  printf ("\n%d, %s - %s", err, ercode, error);
}




ODBC_Login_Information* new_ODBC_Login_Information () {
  //TODO: Use a safe malloc function.
  ODBC_Login_Information* return_Value = (ODBC_Login_Information*)
    malloc(sizeof(ODBC_Login_Information));

  reset_Login_Information(return_Value);

  return(return_Value);
}

void set_User_Name (ODBC_Login_Information* login_Information,
		    char* new_User_Name) {
  login_Information->user_Name = new_User_Name;
  p_Set_Formatted_User_Name(login_Information, new_User_Name);
}

void set_Password (ODBC_Login_Information* login_Information,
		   char* new_Password){
  login_Information->password = new_Password;
  p_Set_Formatted_Password(login_Information, new_Password);
}

void set_Data_Source (ODBC_Login_Information* login_Information,
		      char* new_Data_Source){
  login_Information->data_Source = new_Data_Source;
  p_Set_Formatted_Data_Source(login_Information, new_Data_Source);
}

void login_Information_Set_Up (ODBC_Login_Information* login_Information,
			       char* new_User_Name, char* new_Password,
			       char* new_Data_Source) {

  set_User_Name(login_Information, new_User_Name);
  set_Password(login_Information, new_Password);
  set_Data_Source(login_Information, new_Data_Source);
}

int get_Login_String_Size (ODBC_Login_Information* login_Information) {

  if (!is_Ready(login_Information))
    return(-1);

  int total_Size = 0;
  total_Size += strlen(login_Information->p_Formatted_User_Name);
  total_Size += strlen(login_Information->p_Formatted_Password);
  total_Size += strlen(login_Information->p_Formatted_Data_Source);
  return(total_Size);
}

boolean is_Ready (ODBC_Login_Information* login_Information) {
  if (login_Information->user_Name != NULL && login_Information->password !=
      NULL && login_Information->data_Source != NULL)
    return(true);
  return(false);
}

int print_Login_String (ODBC_Login_Information* login_Information,
		       char *destiny, int maximum_Size) {

  int needed_Size = get_Login_String_Size(login_Information) + 1;

  if (!is_Ready(login_Information))
    return(0);

  if (needed_Size > maximum_Size)
    return(maximum_Size - needed_Size);

  *destiny = '\0';
  strcat(destiny, login_Information->p_Formatted_User_Name);
  strcat(destiny, login_Information->p_Formatted_Password);
  strcat(destiny, login_Information->p_Formatted_Data_Source);
}

void reset_Login_Information (ODBC_Login_Information* login_Information) {
  login_Information->user_Name = NULL;
  login_Information->password = NULL;
  login_Information->data_Source = NULL;
}


//Private.
void p_Set_Formatted_User_Name (ODBC_Login_Information* login_Information,
				char* new_User_Name) {

  char* prefix = "UID=";
  char* suffix  = ";";
  int total_Size = strlen(new_User_Name) + strlen(prefix) + strlen(suffix) + 1;

  login_Information->p_Formatted_User_Name = alloc_String(total_Size);

  p_Mount_Formatted_String(login_Information->p_Formatted_User_Name, prefix,
			   new_User_Name, suffix);
}

void p_Set_Formatted_Password (ODBC_Login_Information* login_Information,
			       char* new_Password) {

  char* prefix = "PWD=";
  char* suffix  = ";";
  int total_Size = strlen(new_Password) + strlen(prefix) + strlen(suffix) + 1;

  login_Information->p_Formatted_Password = alloc_String(total_Size);

  p_Mount_Formatted_String(login_Information->p_Formatted_Password, prefix,
			   new_Password, suffix);
}

void p_Set_Formatted_Data_Source (ODBC_Login_Information* login_Information,
				  char* new_Data_Source) {

  char* prefix = "DSN=";
  char* suffix  = ";";
  int total_Size = strlen(new_Data_Source) + strlen(prefix) + strlen(suffix)
    + 1;

  login_Information->p_Formatted_Data_Source = alloc_String(total_Size);

  p_Mount_Formatted_String(login_Information->p_Formatted_Data_Source, prefix,
			   new_Data_Source, suffix);
}

void p_Mount_Formatted_String (char* destination, char* prefix, char* middle,
			       char* suffix) {

  strcat(destination, prefix);
  strcat(destination, middle);
  strcat(destination, suffix);
}




//TODO: Change malloc to a safe (not unchecked) function.
ODBC_SQL_Statement* new_ODBC_SQL_Statement (ODBC_Facade* logged_In_Facade) {

  ODBC_SQL_Statement* return_Value = malloc(sizeof(ODBC_SQL_Statement));

  SQLAllocHandle(SQL_HANDLE_STMT, logged_In_Facade->connection_Handle,
		 &(return_Value->statement_Handle));

  return_Value->sql_Statement = NULL;

  return(return_Value);
}

void set_SQL_Statement (ODBC_SQL_Statement* odbc_SQL_Statement,
			SQLCHAR* new_SQL_Statement) {

  odbc_SQL_Statement->sql_Statement = new_SQL_Statement;
}

boolean is_SQL_Statement_Ready (ODBC_SQL_Statement* odbc_SQL_Statement) {

  if (odbc_SQL_Statement->sql_Statement == NULL)
    return(false);
  return(true);
}

ODBC_Query_Results* run_SQL_Statement (ODBC_SQL_Statement*
				       odbc_SQL_Statement) {

  SQLExecDirect(odbc_SQL_Statement->statement_Handle,
		odbc_SQL_Statement->sql_Statement, SQL_NTS);
  return(p_New_ODBC_Query_Results(odbc_SQL_Statement));
}


//TODO: Make this use a safe memory allocation.
ODBC_Query_Results* p_New_ODBC_Query_Results (ODBC_SQL_Statement*
					      odbc_SQL_Statement) {

  ODBC_Query_Results* return_Value = malloc(sizeof(ODBC_Query_Results));

  return_Value->associated_Query = odbc_SQL_Statement;

  return(return_Value);
}




//TODO: Allow some basic options to be set, maybe?
ODBC_Facade* new_ODBC_Facade () {

  //TODO: Change the malloc so we can use a safe function.
  ODBC_Facade* return_Facade = (ODBC_Facade*) malloc(sizeof(ODBC_Facade));
  set_Up_Environment_Handle(return_Facade);
  set_Up_Connection_Handle(return_Facade);
  switch_Off_Connection(return_Facade);
  return_Facade->login_Information = new_ODBC_Login_Information();
  return(return_Facade);
}

//TODO: Deal with the return values.
void set_Up_Environment_Handle (ODBC_Facade* odbc_Facade) {

  SQLAllocHandle(SQL_HANDLE_ENV, SQL_NULL_HANDLE,
		 &(odbc_Facade->environment_Handle));
  SQLSetEnvAttr(odbc_Facade->environment_Handle, SQL_ATTR_ODBC_VERSION,
		CLIENT_ODBC_VERSION, 0);
}

void set_Up_Connection_Handle (ODBC_Facade* odbc_Facade) {

  SQLAllocHandle(SQL_HANDLE_DBC, odbc_Facade->environment_Handle,
		 &(odbc_Facade->connection_Handle));
}


//Since ODBC has no standard way of checking connection status, this is done by
//hand in these two methods:
void switch_Off_Connection (ODBC_Facade* odbc_Facade) {

  odbc_Facade->connected = false;
}

void switch_On_Connection (ODBC_Facade* odbc_Facade) {

  odbc_Facade->connected = true;
}

boolean is_Connected (ODBC_Facade* odbc_Facade) {
  return(odbc_Facade->connected);
}

//TODO: Deal with the return values. we could possibly store it on a new struct
//on the facade and let Ada read it using functions.
void connect_With_Data_Source (ODBC_Facade* odbc_Facade) {

  char* login_String = alloc_String (get_Login_String_Size(odbc_Facade->
						      login_Information) + 1);

  print_Login_String(odbc_Facade->login_Information, login_String,
		     get_Login_String_Size(odbc_Facade->login_Information)
		     + 1);

  if (SQL_SUCCEEDED(SQLDriverConnect(odbc_Facade->connection_Handle, NULL,
				     login_String, SQL_NTS, NULL, 0, NULL,
				     SQL_DRIVER_NOPROMPT)))
    switch_On_Connection(odbc_Facade);

  p_Print_Error_Information(odbc_Facade);
}

void log_Into_Data_Source (ODBC_Facade* odbc_Facade, char* new_User_Name,
			   char* new_Password, char* new_Data_Source) {

  login_Information_Set_Up(odbc_Facade->login_Information, new_User_Name,
			   new_Password, new_Data_Source);
  connect_With_Data_Source(odbc_Facade);
}

ODBC_Query_Results* create_And_Run_SQL_Statement (ODBC_Facade*
						  logged_In_Facade, SQLCHAR*
						  new_SQL_Statement) {
  ODBC_SQL_Statement* statement = new_ODBC_SQL_Statement (logged_In_Facade);

  set_SQL_Statement(statement, new_SQL_Statement);

  printf("\n%s\n", new_SQL_Statement);

  return(run_SQL_Statement(statement));
}


//TODO: Allow the user to set which error he wants info from.
//TODO: Return error string instead of printing it?
void p_Print_Error_Information (ODBC_Facade* odbc_Facade) {

  char ercode[6];
  SQLINTEGER  err;
  char error[250];
  SQLSMALLINT size;

  SQLGetDiagRec(SQL_HANDLE_DBC, odbc_Facade->environment_Handle, 1, ercode,
		&err, error, 250, &size);
  printf ("\n%d, %s - %s\n", err, ercode, error);
}




char* alloc_String (int size) {
  char* return_Value = malloc(sizeof(char) * size);
  *return_Value = '\0';
}
