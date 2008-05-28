------------------------------------------------------------------------------
--                                                                          --
--                          APQ DATABASE BINDINGS                           --
--                                                                          --
--				 A P Q - ODBC				    --
--                                  					    --
--                                 S P E C				    --
--                                                                          --
--         Copyright (C) 2002-2007, Warren W. Gay VE3WWG                    --
--         Copyright (C) 2007-2008, Ydea Desenv. de Softwares Ltda          --
--                                                                          --
--                                                                          --
-- APQ is free software;  you can  redistribute it  and/or modify it under  --
-- terms of the  GNU General Public License as published  by the Free Soft- --
-- ware  Foundation;  either version 2,  or (at your option) any later ver- --
-- sion.  APQ is distributed in the hope that it will be useful, but WITH-  --
-- OUT ANY WARRANTY;  without even the  implied warranty of MERCHANTABILITY --
-- or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License --
-- for  more details.  You should have  received  a copy of the GNU General --
-- Public License  distributed with APQ;  see file COPYING.  If not, write  --
-- to  the Free Software Foundation,  59 Temple Place - Suite 330,  Boston, --
-- MA 02111-1307, USA.                                                      --
--                                                                          --
-- As a special exception,  if other files  instantiate  generics from this --
-- unit, or you link  this unit with other files  to produce an executable, --
-- this  unit  does not  by itself cause  the resulting  executable  to  be --
-- covered  by the  GNU  General  Public  License.  This exception does not --
-- however invalidate  any other reasons why  the executable file  might be --
-- covered by the  GNU Public License.                                      --
------------------------------------------------------------------------------

package APQ.ODBC is

private

	--This is just a return type representing the boolean enum in C.
	type C_Bool is new Integer range 0..1;


	--This type points to the C struct, ODBC_Facade.
	type ODBC_Facade is new System.Address;

	--This type points to the results of a query.
	type ODBC_Query_Results is new System.Address;




	--Converts the C enum to the Ada type.
	function C_Bool_To_Boolean (Bool : C_Bool) return Boolean;


	--?
	--TODO: An Ada function should be used to free the strings when done.
	procedure ODBC_Login (Facade : in out ODBC_Facade;
			User_Name, Password, Data_Source : in APQ.String_Ptr);

	--This function should be used to create new ODBC_Facades.
	function New_ODBC_Facade return ODBC_Facade;
	pragma import(C, New_ODBC_Facade, "new_ODBC_Facade");

	--This function sets up the login information and connects with the DS.
	procedure Log_Into_Data_Source (Facade : in ODBC_Facade;
				 User_Name, Password, Data_Source
				 : in System.Address);
	pragma import(C, Log_Into_Data_Source, "log_Into_Data_Source");

	--C function, returns true if ODBC_Facade believes to be connected.
	function Facade_Is_Connected (Facade : ODBC_Facade) return C_Bool;
	pragma import(C, Facade_Is_Connected, "is_Connected");

	function Create_And_Run_SQL_Statement (Facade : ODBC_Facade;
					new_SQL_Statement : System.Address)
		return ODBC_Query_Results;
	pragma import(C, Create_And_Run_SQL_Statement,
	       "create_And_Run_SQL_Statement");

	function Execute_SQL_Statement (Facade : in ODBC_Facade;
				 SQL_Statement : in String)
				 return ODBC_Query_Results;

end APQ.ODBC;
