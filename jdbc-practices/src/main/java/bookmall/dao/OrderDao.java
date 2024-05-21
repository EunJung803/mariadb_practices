package bookmall.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import bookmall.vo.CartVo;
import bookmall.vo.CategoryVo;
import bookmall.vo.OrderBookVo;
import bookmall.vo.OrderVo;

public class OrderDao {
	
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

	public int insert(OrderVo vo) {
		
		int result = 0;
		
		try (
			Connection conn = getConnection();
			PreparedStatement pstmt1 = conn.prepareStatement("insert into orders(user_no, number, payment, shipping, status) values(?, ?, ?, ?, ?)");
			PreparedStatement pstmt2 = conn.prepareStatement("select last_insert_id() from dual");
		) {
			
			pstmt1.setLong(1, vo.getUserNo());
			pstmt1.setString(2, vo.getNumber());
			pstmt1.setInt(3, vo.getPayment());
			pstmt1.setString(4, vo.getShipping());
			pstmt1.setString(5, vo.getStatus());
			result = pstmt1.executeUpdate();
			
			ResultSet rs = pstmt2.executeQuery();
			
			vo.setNo(rs.next() ? rs.getLong(1) : null);
			
			rs.close();
		     
		} catch (SQLException e) {
			System.out.println("error: " + e);
		}
	    
		return result;
		
	}

	public OrderVo findByNoAndUserNo(Long no, Long userNo) {

		OrderVo vo = null;
		
		try (
	    	Connection conn = getConnection();
    		PreparedStatement pstmt = conn.prepareStatement("select no, user_no, number, payment, shipping, status from orders where no = ? and user_no = ?");
	    ) {
			
			pstmt.setLong(1, no);
			pstmt.setLong(2, userNo);
			
			ResultSet rs = pstmt.executeQuery();
			
			if(rs.next()) {
				vo = new OrderVo();
				
				String number = rs.getString(3);
				int payemnt = rs.getInt(4);
				String shipping = rs.getString(5);
				String status = rs.getString(6);
				
				vo.setNo(no);
				vo.setUserNo(userNo);
				vo.setNumber(number);
				vo.setPayment(payemnt);
				vo.setShipping(shipping);
				vo.setStatus(status);
			}
				
			rs.close();
			
		     
		} catch (SQLException e) {
			System.out.println("error: " + e);
		}

		return vo;
		
	}

	public int deleteByNo(Long no) {
		
		int result = 0;
		
		try (
			Connection conn = getConnection();
			PreparedStatement pstmt = conn.prepareStatement("delete from orders where no = ?");
		) {
			
			pstmt.setLong(1, no);
			result = pstmt.executeUpdate();
			
		} catch (SQLException e) {
			System.out.println("error: " + e);
		}
		
		return result;
		
	}

	public int insertBook(OrderBookVo vo) {
		
		int result = 0;
		
		try (
			Connection conn = getConnection();
			PreparedStatement pstmt = conn.prepareStatement("insert into orders_book(order_no, book_no, quantity, price) values(?, ?, ?, ?)");
		) {
			
			pstmt.setLong(1, vo.getOrderNo());
			pstmt.setLong(2, vo.getBookNo());
			pstmt.setInt(3, vo.getQuantity());
			pstmt.setInt(4, vo.getPrice());
				
			result = pstmt.executeUpdate();
			
		     
		} catch (SQLException e) {
			System.out.println("error: " + e);
		}
	    
		return result;
	}

	public List<OrderBookVo> findBooksByNoAndUserNo(Long no, Long userNo) {
		
		List<OrderBookVo> result = new ArrayList<>();
		
		try (
	    	Connection conn = getConnection();
    		PreparedStatement pstmt = conn.prepareStatement("select a.order_no, a.book_no, a.quantity, a.price, b.title"
									    				+ "	from orders_book a, book b, orders c"
									    				+ "	where a.book_no = b.no"
									    				+ "	and c.user_no = ?"
									    				+ "	and a.order_no = ?");
	    ) {
			
			pstmt.setLong(1, userNo);
			pstmt.setLong(2, no);

    		ResultSet rs = pstmt.executeQuery();
			
			while(rs.next()) {
	    		Long orderNo = rs.getLong(1);
	    		Long bookNo = rs.getLong(2);
	    		int quantity = rs.getInt(3);
	    		int price = rs.getInt(4);
	    		String bookTitle = rs.getString(5);
	    		
	    		OrderBookVo vo = new OrderBookVo();
	    		vo.setOrderNo(orderNo);
	    		vo.setBookNo(bookNo);
	    		vo.setQuantity(quantity);
	    		vo.setPrice(price);
	    		vo.setBookTitle(bookTitle);
	    		
	    		result.add(vo);
	    	}
			
			rs.close();
		     
		} catch (SQLException e) {
			System.out.println("error: " + e);
		}
		
		return result;
	}

	public int deleteBooksByNo(Long no) {

		int result = 0;
		
		try (
			Connection conn = getConnection();
			PreparedStatement pstmt = conn.prepareStatement("delete from orders_book where order_no = ?");
		) {
			
			pstmt.setLong(1, no);
			result = pstmt.executeUpdate();
			
		} catch (SQLException e) {
			System.out.println("error: " + e);
		}
		
		return result;
		
	}
}
