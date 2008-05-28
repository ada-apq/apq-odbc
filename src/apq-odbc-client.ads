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

with System;
with Interfaces;
with Ada.Text_IO.C_Streams;
with Ada.Finalization;
with Ada.Streams.Stream_IO;
with Ada.Calendar;
with Ada.Strings.Bounded;
with Ada.Strings.Unbounded;
with Interfaces.C_Streams;

with APQ.MySQL.Client; --To be removed!
with APQ.ODBC;

package APQ.ODBC.Client is

	-----------------------
	-- CONNECTION  TYPE  --
	-----------------------
	type ODBC_Connection_Type is new APQ.Root_Connection_Type with private;


	type ODBC_Query_Type is new APQ.Root_Query_Type with private;




	--Methods inherited from Root_Connection_Type
	function Engine_Of(C : ODBC_Connection_Type) return Database_Type;


	procedure Connect(C : in out ODBC_Connection_Type);

	procedure Connect(C : in out ODBC_Connection_Type;
		Same_As : Root_Connection_Type'Class);

	procedure Disconnect(C : in out ODBC_Connection_Type);

	function Is_Connected(C : ODBC_Connection_Type) return Boolean;

	procedure Reset(C : in out ODBC_Connection_Type);


	function Error_Message(C : ODBC_Connection_Type) return String;

	procedure Open_DB_Trace(C : in out ODBC_Connection_Type;
		Filename : String; Mode : Trace_Mode_Type := Trace_APQ);


	function Query_Factory( C: in ODBC_Connection_Type )
			return Root_Query_Type'Class;




	--Methods inherited from Root_Query_Type
	function Engine_Of(Q : ODBC_Query_Type) return Database_Type;


	procedure Execute(Query : in out ODBC_Query_Type;
		   Connection : in out Root_Connection_Type'Class);

	procedure Execute_Checked(Query : in out ODBC_Query_Type;
			   Connection : in out Root_Connection_Type'Class;
			   Msg : String := "");


	procedure Begin_Work(Query : in out ODBC_Query_Type;
		Connection : in out Root_Connection_Type'Class);

	procedure Commit_Work(Query : in out ODBC_Query_Type;
		Connection : in out Root_Connection_Type'Class);

	procedure Rollback_Work(Query : in out ODBC_Query_Type;
		Connection : in out Root_Connection_Type'Class);


	procedure Rewind(Q : in out ODBC_Query_Type);

	procedure Fetch(Q : in out ODBC_Query_Type);

	procedure Fetch(Q : in out ODBC_Query_Type; TX : Tuple_Index_Type);


	function End_of_Query(Q : ODBC_Query_Type) return Boolean;


	function Tuple(Q : ODBC_Query_Type) return Tuple_Index_Type;

	function Tuples(Q : ODBC_Query_Type) return Tuple_Count_Type;

	function Columns(Q : ODBC_Query_Type) return Natural;


	function Value(Query : ODBC_Query_Type; CX : Column_Index_Type)
		return String;


	function Column_Name(Query : ODBC_Query_Type; Index : Column_Index_Type)
		      return String;

	function Column_Index(Query : ODBC_Query_Type; Name : String)
		       return Column_Index_Type;


	function Result(Query : ODBC_Query_Type) return Natural;

	function Is_Null(Q : ODBC_Query_Type; CX : Column_Index_Type)
		  return Boolean;


	function Command_Oid(Query : ODBC_Query_Type) return Row_ID_Type;

	function Null_Oid(Query : ODBC_Query_Type) return Row_ID_Type;


	function Error_Message(Query : ODBC_Query_Type) return String;


	function Is_Duplicate_Key(Query : ODBC_Query_Type) return Boolean;


	function SQL_Code(Query : ODBC_Query_Type) return SQL_Code_Type;




private

	type ODBC_Connection_Type is new APQ.Root_Connection_Type with
		record
			Facade    : ODBC_Facade;
		end record;


	type ODBC_Query_Type is new APQ.Root_Query_Type with
		record
			PlaceHolder : Integer;
		end record;




	--Methods inherited from Limited_Controlled
	procedure Initialize(C : in out ODBC_Connection_Type);

	procedure Finalize(C : in out ODBC_Connection_Type);


	procedure Initialize(C : in out ODBC_Query_Type);

	procedure Finalize(C : in out ODBC_Query_Type);

end APQ.ODBC.Client;
