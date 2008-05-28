------------------------------------------------------------------------------
--                                                                          --
--                          APQ DATABASE BINDINGS                           --
--                                                                          --
--				 A P Q - ODBC				    --
--                                  					    --
--                                 B O D Y				    --
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

package body APQ.ODBC is

	function C_Bool_To_Boolean (Bool : C_Bool) return Boolean is
	begin
		if Bool = 0 then
			return False;
		else
			return True;
		end if;
	end C_Bool_To_Boolean;




	procedure  ODBC_Login (Facade : in out ODBC_Facade;
			User_Name, Password, Data_Source : in String_Ptr) is
		use Interfaces.C.Strings;
		Dummy		: char_array_access; --TODO: Remove this Dummy.
		C_User_Name	: System.Address := System.Null_Address;
		C_Password	: System.Address := System.Null_Address;
		C_Data_Source	: System.Address := System.Null_Address;
	begin
		C_String(To_String(User_Name), Dummy, C_User_Name);
		C_String(To_String(Password), Dummy, C_Password);
		C_String(To_String(Data_Source), Dummy, C_Data_Source);

		Log_Into_Data_Source(Facade => Facade, User_Name =>
			       C_User_Name, Password => C_Password,
		       Data_Source => C_Data_Source);
	end ODBC_Login;


	function Execute_SQL_Statement (Facade : in ODBC_Facade;
				 SQL_Statement : in String)
				 return ODBC_Query_Results is
		use interfaces.C.Strings;
		Dummy		: char_array_access; --TODO: Remove this Dummy.
		C_SQL_Statement	: System.Address := System.Null_Address;
		Return_Value	: ODBC_Query_Results;
	begin

		C_String(SQL_Statement, Dummy, C_SQL_Statement);
		--Converts the sql statement of the query to a C string.

		Return_Value := Create_And_Run_SQL_Statement(
			Facade => Facade, new_SQL_Statement => C_SQL_Statement);

		return Return_Value;
	end Execute_SQL_Statement;

end APQ.ODBC;
