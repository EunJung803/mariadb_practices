package bookmall.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import bookmall.vo.CartVo;
import bookshop.vo.BookVo;

public class CartDao {

	private Connection getConnection() throws SQLException {

	    Connection conn = null;

        try {
    	    //1. JDBC Driver 로딩 
			Class.forName("org.mariadb.jdbc.Driver");

	        //2. 연결하기 
			String url = "jdbc:mariadb://192.168.64.7:3306/bookmall?charset=utf8";
			conn = DriverManager.getConnection(url, "bookmall", "bookmall");
			
		} catch (ClassNotFoundException e) {
			System.out.println("드라이버 로딩 실패: " + e);
		} 
        
	    return conn;
	}

	public int insert(CartVo vo) {
		
		int result = 0;
		
		try (
			Connection conn = getConnection();
			PreparedStatement pstmt = conn.prepareStatement("insert into cart(user_no, book_no, quantity) values(?, ?, ?)");
		) {
			
			pstmt.setLong(1, vo.getUserNo());
			pstmt.setLong(2, vo.getBookNo());
			pstmt.setInt(3, vo.getQuantity());

			result = pstmt.executeUpdate();
		     
		} catch (SQLException e) {
			System.out.println("error: " + e);
		}
	    
		return result;
		
	}

	public List<CartVo> findByUserNo(Long no) {

		List<CartVo> result = new ArrayList<>();
		
		try (
	    	Connection conn = getConnection();
    		PreparedStatement pstmt = conn.prepareStatement("select a.user_no, a.book_no, b.title, a.quantity from cart a, book b where a.book_no = b.no and a.user_no = ?");
	    ) {
			
			pstmt.setLong(1, no);
			ResultSet rs = pstmt.executeQuery();
			
	    	while(rs.next()) {
	    		Long userNo = rs.getLong(1);
	    		Long bookNo = rs.getLong(2);
	    		String bookTitle = rs.getString(3);
	    		int quantity = rs.getInt(4);
	    		
	    		CartVo vo = new CartVo();
	    		vo.setUserNo(userNo);
	    		vo.setBookNo(bookNo);
	    		vo.setBookTitle(bookTitle);
	    		vo.setQuantity(quantity);
	    		
	    		result.add(vo);
	    	}
	    	
	    	rs.close();
		     
		} catch (SQLException e) {
			System.out.println("error: " + e);
		}
	    
		return result;
	}

	public int deleteByUserNoAndBookNo(Long userNo, Long bookNo) {

		int result = 0;
		
		try (
			Connection conn = getConnection();
			PreparedStatement pstmt = conn.prepareStatement("delete from cart where user_no = ? and book_no = ?");
		) {
			
			pstmt.setLong(1, userNo);
			pstmt.setLong(2, bookNo);
			
			result = pstmt.executeUpdate();
			
		} catch (SQLException e) {
			System.out.println("error: " + e);
		}
		
		return result;
		
	}
}
