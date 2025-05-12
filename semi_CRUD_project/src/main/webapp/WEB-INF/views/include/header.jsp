<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<style>
  .top-bar {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 20px 30px;
    font-family: sans-serif;
    background-color: #e2e6ea;
    border-bottom: 1px solid #ddd;
  }

  .top-bar a {
    margin-left: 10px;
    text-decoration: none;
    color: #333;
    font-size: 14px;
    transition: all 0.2s ease-in-out;
  }

  .top-bar a:visited {
    color: #333;
  }

  .top-bar a:hover {
    color: #007bff;
    text-decoration: underline;
  }

  .top-bar .home-link {
    font-size: 18px;
    font-weight: bold;
  }
</style>

<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<div class="top-bar">
	<div>
		<a href="${pageContext.request.contextPath}/" class="home-link">홈으로</a>
	</div>
	<div>
		<c:if test="${empty member}">
			<a href="${pageContext.request.contextPath}/loginForm">로그인</a>
			<a href="${pageContext.request.contextPath}/registerForm">회원가입</a>
		</c:if>
		<c:if test="${not empty member}">
			<c:if test="${member.isManager eq 'Y'}">
				<a href="${pageContext.request.contextPath}/userList">회원목록</a>
			</c:if>
			<a href="${pageContext.request.contextPath}/detailView?userid=${sessionScope.member.userId}">내 정보</a>
			<a href="${pageContext.request.contextPath}/logout">로그아웃</a>
		</c:if>
	</div>
</div>

</body>
</html>