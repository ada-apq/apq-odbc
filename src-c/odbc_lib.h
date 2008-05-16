//TODO: Add a header with company information.
//TODO: Change this to Ada?

#include <windows.h>
#include <stdio.h>
#include <sql.h>
#include <sqlext.h>
#include <strings.h>

#ifndef _ODBC_LIB_
#define _ODBC_LIB_

#define CLIENT_ODBC_VERSION (void *)SQL_OV_ODBC3

//TODO: Make all handles one big struct (no reason to deal with them in Ada.
//TODO: Or maybe not, but at least environment and connection should be glued.

//TODO: Move this from this to a helper file.
typedef enum boolean{
  true = 1, false = 0
} boolean;




typedef struct odbc_login_information {
  char* user_Name;
  char* password;
  char* data_Source;

  char* p_Formatted_User_Name;
  char* p_Formatted_Password;
  char* p_Formatted_Data_Source;
} ODBC_Login_Information;

//Public methods for ODBC_Login_Information.
ODBC_Login_Information* new_ODBC_Login_Information ();

void set_User_Name (ODBC_Login_Information* login_Information,
		    char* new_User_Name);

void set_Password (ODBC_Login_Information* login_Information,
		   char* new_Password);

void set_Data_Source (ODBC_Login_Information* login_Information,
		    char* new_Data_Source);

//Returns the size of the login string (minus the trailing \0).
int get_Login_String_Size (ODBC_Login_Information* login_Information);

//Returns wether the ODBC_Login_Information has all the needed values.
boolean is_Ready (ODBC_Login_Information* login_Information);

//Prints the login string onto destiny, as long as maximum_Size is bigger than
//the size of the string. It returns the size of the log in string if
//successful or minus the extra space needed otherwise. If login_Information
//isn't ready, it returns 0.
int print_Login_String (ODBC_Login_Information* login_Information,
			 char *destiny, int maximum_Size);

//This method sets all the login_Information fields to null. free not used.
void reset_Login_Information (ODBC_Login_Information* login_Information);


//Private methods for ODBC_Login_Information.
void p_Set_Formatted_User_Name (ODBC_Login_Information* login_Information,
				char* new_User_Name);

void p_Set_Formatted_Password (ODBC_Login_Information* login_Information,
			       char* new_Password);

void p_Set_Formatted_Data_Source (ODBC_Login_Information* login_Information,
				  char* new_Data_Source);

void p_Mount_Formatted_String (char* destination, char* prefix, char* middle,
			       char* suffix);




typedef struct odbc_facade {
  SQLHENV environment_Handle;
  SQLHDBC connection_Handle;
  ODBC_Login_Information* login_Information;
} ODBC_Facade;

ODBC_Facade* new_ODBC_Facade ();

void set_Up_Environment_Handle (ODBC_Facade* odbc_Facade);

void set_Up_Connection_Handle (ODBC_Facade* odbc_Facade);

void set_Up_ODBC_Facade_Login (ODBC_Facade* odbc_Facade, char* new_User_Name,
			       char* new_Password, char* new_Data_Source);

void connect_With_Data_Source (ODBC_Facade* odbc_Facade);

void p_Print_Error_Information (ODBC_Facade* odbc_Facade);




//Helper functions. Should be put on another file.
char* alloc_String (int size);
#endif
