<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
<!-- Bootstrap CSS/JS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<style>
  body {
    background-color: #f8f9fa;
  }

  .nav-bar {
    padding: 15px;
    display: flex;
    justify-content: center;
    gap: 60px;
    font-weight: bold;
    background-color: white;
    border-radius: 8px;
    margin-bottom: 40px;
    box-shadow: 0 2px 4px rgba(0,0,0,0.1);
  }

  .nav-bar a {
    text-decoration: none;
    color: #333;
  }

  .nav-bar a:hover {
    color: #0d6efd;
  }

  .section {
    margin-bottom: 50px;
  }

  .section-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    background-color: #ffffff;
    padding: 16px;
    border-top-left-radius: 10px;
    border-top-right-radius: 10px;
    border-bottom: 1px solid #dee2e6;
  }

  .section-header h3 {
    margin: 0;
  }

  .section-header a {
    font-size: 14px;
    text-decoration: none;
    color: #0d6efd;
  }

  .table {
    margin: 0;
    background-color: white;
    border-radius: 0 0 10px 10px;
    overflow: hidden;
  }

  .table td a {
    text-decoration: none;
    color: #000;
  }

  .table td a:hover {
    text-decoration: underline;
    color: #0d6efd;
  }

  .clickable-row:hover {
    background-color: #f1f1f1;
    cursor: pointer;
  }
</style>

<title>Home</title>
</head>
<body>
	<%@ include file="include/header.jsp"%>

	<div class="container my-5">

		<div class="nav-bar">
			<c:forEach items="${boardType}" var="board" varStatus="status">		
				<a href="${pageContext.request.contextPath}/postList?boardNo=${board.boardNo}">${board.boardName}</a>
			</c:forEach>
		</div>

		<!-- 자유게시판 -->
		<div class="section shadow-sm">
			<div class="section-header">
				<h3>자유게시판</h3>
				<a href="${pageContext.request.contextPath}/postList?boardNo=1">더 보기</a>
			</div>
			<table class="table table-bordered table-hover text-center">
				<thead class="table-light">
					<tr>
						<th>제목</th>
						<th>작성자</th>
						<th>작성일</th>
					</tr>
				</thead>
				<tbody>
					<c:if test="${empty pageResponse1.list}">
						<tr>
							<td colspan="3">존재하는 게시물이 없습니다</td>
						</tr>
					</c:if>
					<c:forEach items="${pageResponse1.list}" var="post" varStatus="status">
						<tr class="clickable-row" data-href="${pageContext.request.contextPath}/postDetailView?postno=${post.postNo}">
							<td>${post.postTitle}</td>
							<td>${post.userName}</td>
							<td><fmt:formatDate value="${post.postRegDate}" pattern="yyyy년 MM월 dd일" /></td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</div>

		<!-- 공지사항 -->
		<div class="section shadow-sm">
			<div class="section-header">
				<h3>공지사항</h3>
				<a href="${pageContext.request.contextPath}/postList?boardNo=2">더 보기</a>
			</div>
			<table class="table table-bordered table-hover text-center">
				<thead class="table-light">
					<tr>
						<th>제목</th>
						<th>작성자</th>
						<th>작성일</th>
					</tr>
				</thead>
				<tbody>
					<c:if test="${empty pageResponse2.list}">
						<tr>
							<td colspan="3">존재하는 게시물이 없습니다</td>
						</tr>
					</c:if>
					<c:forEach items="${pageResponse2.list}" var="post" varStatus="status">
						<tr class="clickable-row" data-href="${pageContext.request.contextPath}/postDetailView?postno=${post.postNo}">
							<td>${post.postTitle}</td>
							<td>${post.userName}</td>
							<td><fmt:formatDate value="${post.postRegDate}" pattern="yyyy년 MM월 dd일" /></td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</div>

		<!-- Q&A 게시판 -->
		<div class="section shadow-sm">
			<div class="section-header">
				<h3>Q&A게시판</h3>
				<a href="${pageContext.request.contextPath}/postList?boardNo=3">더 보기</a>
			</div>
			<table class="table table-bordered table-hover text-center">
				<thead class="table-light">
					<tr>
						<th>제목</th>
						<th>작성자</th>
						<th>작성일</th>
					</tr>
				</thead>
				<tbody>
					<c:if test="${empty pageResponse3.list}">
						<tr>
							<td colspan="3">존재하는 게시물이 없습니다</td>
						</tr>
					</c:if>
					<c:forEach items="${pageResponse3.list}" var="post" varStatus="status">
						<tr class="clickable-row" data-href="${pageContext.request.contextPath}/postDetailView?postno=${post.postNo}">
							<td>${post.postTitle}</td>
							<td>${post.userName}</td>
							<td><fmt:formatDate value="${post.postRegDate}" pattern="yyyy년 MM월 dd일" /></td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</div>

	</div>

	<script>
	  document.addEventListener("DOMContentLoaded", function() {
	    const rows = document.querySelectorAll(".clickable-row");
	    rows.forEach(row => {
	      row.style.cursor = "pointer";
	      row.addEventListener("click", function() {
	        window.location.href = row.dataset.href;
	      });
	    });
	  });
	</script>
</body>
</html>
