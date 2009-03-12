------------------------------------------------------------------------------
--                                                                          --
--                          APQ DATABASE BINDINGS                           --
--                                                                          --
--				 A P Q - ODBC				    --
--                                  					    --
--                                 B O D Y				    --
--                                                                          --
--         Copyright (C) 2002-2007, Warren W. Gay VE3WWG                    --
--         Copyright (C) 2007-2009, Ada Works Project                       --
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


	procedure Connect(C : in out ODBC_Connection_Type; Check_Connection : Boolean := True) is
	begin

		if Check_Connection and then Is_Connected(C) then
			--TODO: Make an exception throw here
			Ada.Text_IO.Put_Line("Error: Already Connecter");
			return;
		end if;

		ODBC_Login (C.Facade, C.User_Name, C.User_Password, C.Host_Name);
	end Connect;

	procedure Connect(C : in out ODBC_Connection_Type;
		Same_As : Root_Connection_Type'Class) is
	begin
		Ada.Text_IO.Put_Line("I don't even know what I am supposed to do here.");
	end Connect;

	procedure Disconnect(C : in out ODBC_Connection_Type) is
	begin
		Ada.Text_IO.Put_Line("Disconnected!");
	end Disconnect;

	function Is_Connected(C : ODBC_Connection_Type) return Boolean is
	begin
		return C_Bool_To_Boolean(Facade_Is_Connected(C.Facade));
	end Is_Connected;

	procedure Reset(C : in out ODBC_Connection_Type) is
	begin
		Ada.Text_IO.Put_Line("Disconnected!");
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
		Query : ODBC_Query_Type;
	begin
		return Query;
	end Query_Factory;




	function Engine_Of(Q : ODBC_Query_Type) return Database_Type is
	begin

		return Engine_ODBC;
	end Engine_Of;


	procedure Execute(Query : in out ODBC_Query_Type;
		   Connection : in out Root_Connection_Type'Class) is
		SQL_Statement	: String
			:= To_String(Query);
		Dummy		:	 ODBC_Query_Results;
	begin

		Ada.Text_IO.Put("The electricity will run through your body...");

		Dummy := Execute_SQL_Statement(Facade =>
					 ODBC_Connection_Type(Connection).Facade,
				 SQL_Statement => SQL_Statement);
	end Execute;

	procedure Execute_Checked(Query : in out ODBC_Query_Type;
			   Connection : in out Root_Connection_Type'Class;
			   Msg : String := "") is
		begin

		Ada.Text_IO.Put("Checking sponge... ok, it is wet.");
	end Execute_Checked;

	procedure Begin_Work(Query : in out ODBC_Query_Type;
		      Connection : in out Root_Connection_Type'Class) is
	begin

		Ada.Text_IO.Put_Line("Mommy!");
	end Begin_Work;

	procedure Commit_Work(Query : in out ODBC_Query_Type;
		       Connection : in out Root_Connection_Type'Class)is
	begin

		Ada.Text_IO.Put_Line("Mommy!");
	end Commit_Work;

	procedure Rollback_Work(Query : in out ODBC_Query_Type;
			 Connection : in out Root_Connection_Type'Class) is
	begin

		Ada.Text_IO.Put_Line("Mommy!");
	end Rollback_Work;


	procedure Rewind(Q : in out ODBC_Query_Type)is
	begin

		Ada.Text_IO.Put_Line("Mommy!");
	end Rewind;

	procedure Fetch(Q : in out ODBC_Query_Type) is
	begin


		Ada.Text_IO.Put_Line("Mommy!");
	end Fetch;

	procedure Fetch(Q : in out ODBC_Query_Type; TX : Tuple_Index_Type) is
	begin

		Ada.Text_IO.Put_Line("Mommy!");
	end Fetch;


	function End_of_Query(Q : ODBC_Query_Type) return Boolean is
	begin

		return True;
	end End_Of_Query;


	function Tuple(Q : ODBC_Query_Type) return Tuple_Index_Type is
	begin

		return 0;
	end Tuple;

	function Tuples(Q : ODBC_Query_Type) return Tuple_Count_Type is
	begin

		return 0;
	end Tuples;

	function Columns(Q : ODBC_Query_Type) return Natural is
	begin

		return 1;
	end Columns;


	function Value(Query : ODBC_Query_Type; CX : Column_Index_Type)
		return String is
	begin

		return "Null";
	end Value;


	function Column_Name(Query : ODBC_Query_Type; Index : Column_Index_Type)
		      return String is
	begin

		return "Mariazinha";
	end Column_Name;


	function Column_Index(Query : ODBC_Query_Type; Name : String)
		       return Column_Index_Type is
		begin

		return 1;
	end Column_Index;


	function Result(Query : ODBC_Query_Type) return Natural is
		begin

		return 1;
	end Result;

	function Is_Null(Q : ODBC_Query_Type; CX : Column_Index_Type)
		  return Boolean is
	begin

		return True;
	end Is_Null;


	function Command_Oid(Query : ODBC_Query_Type) return Row_ID_Type is
	begin

		return 0;
	end Command_Oid;

	function Null_Oid(Query : ODBC_Query_Type) return Row_ID_Type is
	begin

		return 0; --what did you expect?
	end Null_Oid;


	function Error_Message(Query : ODBC_Query_Type) return String is
	begin

		return "Error: Giraffales didn't bring a square ball.";
	end Error_Message;

	function Is_Duplicate_Key(Query : ODBC_Query_Type) return Boolean is
	begin

		return True;
	end Is_Duplicate_Key;


	--Put here the value of the last thing that can be checked with
	--SQL_SUCCEEDED.
	function SQL_Code(Query : ODBC_Query_Type) return SQL_Code_Type is
	begin

		return 0;
	end SQL_Code;




	--Private methods.

	procedure Initialize(C : in out ODBC_Connection_Type) is
	begin
		Ada.Text_IO.Put_Line("Pato, pato, pato, pato, pato, pato...");
		C.Facade := New_ODBC_Facade;
	end Initialize;

	procedure Finalize(C : in out ODBC_Connection_Type) is
	begin
		Ada.Text_IO.Put_Line("Ganso!");
	end Finalize;


	procedure Initialize(C : in out ODBC_Query_Type) is
	begin
		Ada.Text_IO.Put_Line("I want a new duck!");
	end Initialize;

	procedure Finalize(C : in out ODBC_Query_Type) is
	begin
		Ada.Text_IO.Put_Line("Quack quack quack quack quack quack.");
	end Finalize;

end APQ.ODBC.Client;
