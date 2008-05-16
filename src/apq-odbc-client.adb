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

--TODO: This is just an skeleton. All methods still need implementation.

package body APQ.ODBC.Client is

	function Engine_Of(C : ODBC_Connection_Type) return Database_Type is
	begin
		return Engine_ODBC;
	end Engine_Of;


	procedure Connect(C : in out ODBC_Connection_Type) is
	begin
		Ada.Text_IO.Put_Line("Conectando...");

		if Is_Connected(C) then
			--TODO: Make an exception throw here
			Ada.Text_IO.Put_Line("Erro: conexão já conectada");
			return;
		end if;

		Pass_On_Login_Information (C.Facade, C.User_Name,
			     C.User_Password, C.Host_Name);
		Connect_With_Data_Source(C.Facade);
	end Connect;

	procedure Connect(C : in out ODBC_Connection_Type;
		Same_As : Root_Connection_Type'Class) is
	begin
		Ada.Text_IO.Put_Line("I don't even know what I am supposed to do here.");
	end Connect;

	procedure Disconnect(C : in out ODBC_Connection_Type) is
	begin
		Ada.Text_IO.Put_Line("Disconnected!");
		C.Connected := false;
	end Disconnect;

	function Is_Connected(C : ODBC_Connection_Type) return Boolean is
	begin
		return C.Connected;
	end Is_Connected;

	procedure Reset(C : in out ODBC_Connection_Type) is
	begin
		Ada.Text_IO.Put_Line("Disconnected!");
		C.Connected := false;
	end Reset;


	function Error_Message(C : ODBC_Connection_Type) return String is
	begin
		return "";
	end Error_Message;

	procedure Open_DB_Trace(C : in out ODBC_Connection_Type;
			Filename : String; Mode : Trace_Mode_Type := Trace_APQ) is
	begin
		Ada.Text_IO.Put_Line("Pffffffft!");
	end Open_DB_Trace;


	function Query_Factory( C: in ODBC_Connection_Type )
			return Root_Query_Type'Class is
		Query : APQ.MySQL.Client.query_type;
	begin
		return Query;
	end Query_Factory;




	procedure Initialize(C : in out ODBC_Connection_Type) is
	begin
		Ada.Text_IO.Put_Line("Pato, pato, pato, pato, pato, pato...");
		C.Facade := New_ODBC_Facade;
	end Initialize;

	procedure Finalize(C : in out ODBC_Connection_Type) is
	begin
		Ada.Text_IO.Put_Line("Ganso!");
	end Finalize;

end APQ.ODBC.Client;
