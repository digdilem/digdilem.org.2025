if (document.layers)
	{
	if (screen.colorDepth < 16) { document.write("<BODY id=back2  BGCOLOR=333333>Maaan, you are using less than 16 Bit colors ... welcome to the 21st century we are using 32 Bit here !"); }
	  else if (screen.colorDepth >= 32) { document.write("<BODY id=back2 BGCOLOR=333333>"); }
	  else if (screen.colorDepth < 32) { document.write("<BODY id=back2  BGCOLOR=373437>"); }
	}
else if (document.all)
	{
	if (screen.colorDepth < 16) { document.write("<BODY id=back2  BGCOLOR=333333>Maaan, you are using less than 16 Bit colors ... welcome to the 21st century we are using 32 Bit here !"); }
       else if (screen.colorDepth >= 32) { document.write("<BODY id=back2  BGCOLOR=333333>"); }
       else if (screen.colorDepth < 32) { document.write("<BODY id=back2  BGCOLOR=373437>");}


	}