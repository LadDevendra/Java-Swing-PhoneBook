///*
// * To change this license header, choose License Headers in Project Properties.
// * To change this template file, choose Tools | Templates
// * and open the template in the editor.
// */
//package contactmanager;
//
///**
// *
// * @author Devendra Lad
// */
//
//import java.sql.*;
//
//public class ContactManager
//{
//static Connection conn = null;
//	/**
//	 * If this doesn't work, do the following (from StackOverflow):
//         * 
//         * right click on
//         * project properties --> Java Build Path --> Libraries --> add Jar to your
//         * project(which you already downloaded)  This is the MySQL JDBC
//         * driver.  This worked for me in NetBeans.
//	 */
//	public static void main(String[] args)
//	{
//	try
//		{
//                Class.forName("com.mysql.jdbc.Driver").newInstance();
//		conn = DriverManager.getConnection("jdbc:mysql://localhost/ContactList?useSSL=false&user=root&password=dev123");
//		Statement stmt = conn.createStatement();
//		//ResultSet rs = stmt.executeQuery("SELECT * FROM DEPARTMENT;");
//		
//		String storedProc="{call getAllContacts()}";
//		PreparedStatement pstmt=conn.prepareStatement(storedProc);
//		//pstmt.setString(1,someVariable);
//		pstmt.execute(storedProc);
//                //pstmt.setString(1, "Rain");
//		ResultSet rs1 = pstmt.getResultSet();
//		while (rs1.next())
//			{
//			System.out.println(rs1.getString("fname"));
//			}
//		rs1.close();
//		System.out.println("Success!!");
//		conn.close();
//                
//                
//                //        /* Create and display the form */
////        java.awt.EventQueue.invokeLater(new Runnable() {
////            public void run() {
////                new ContactManagerUI().setVisible(true);
////            }
////        });
//
//		}
//	catch(Exception ex)
//		{
//		System.out.println("Error in connection: " + ex.getMessage());
//		}
//	}
//
//}
