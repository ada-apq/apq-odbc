/*
 * This code was inside the APQ.ODBC C code and I believe is a test
 * Alex Abate Biral implemented while doing his work on this library
 *
 * It's here for historic reasons
 */
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

