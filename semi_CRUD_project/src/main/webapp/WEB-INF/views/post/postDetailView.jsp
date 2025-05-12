<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>게시글 상세</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
<%@ include file="../include/header.jsp"%>

<div class="container-fluid px-4 mt-5">
  <div class="mx-auto" style="max-width: 900px;">
    <div class="card shadow-sm">
      <div class="card-body">
        <h2 class="card-title mb-3">${postDetail.postTitle}</h2>
        <div class="text-muted small mb-4">
          작성자: ${postDetail.userName}<br/>
          작성일: <fmt:formatDate value="${postDetail.postRegDate}" pattern="yyyy년 MM월 dd일 HH:mm:ss"/><br/>
          <c:if test="${not empty postDetail.postModDate}">
            수정일: <fmt:formatDate value="${postDetail.postModDate}" pattern="yyyy년 MM월 dd일 HH:mm:ss"/>
          </c:if>
        </div>

        <div class="card-text" style="white-space: pre-wrap; line-height: 1.6;">
          ${postDetail.postContent}
        </div>

        <div class="mt-4 text-end">
          <a href="${pageContext.request.contextPath}/postList?boardNo=${postDetail.boardNo}" class="btn btn-secondary">목록</a>

		<c:choose>
		  <c:when test="${sessionScope.member.userNo eq postDetail.userNo}">
		    <a href="${pageContext.request.contextPath}/postUpdateForm?postNo=${postDetail.postNo}" class="btn btn-primary">수정</a>
		    <a href="${pageContext.request.contextPath}/postDeleteForm?postNo=${postDetail.postNo}&userId=${sessionScope.member.userId}&boardNo=${postDetail.boardNo}" class="btn btn-danger">삭제</a>
		  </c:when>
		  <c:when test="${sessionScope.member.isManager eq 'Y'}">
		    <a href="${pageContext.request.contextPath}/postUpdateForm?postNo=${postDetail.postNo}" class="btn btn-primary">수정</a>
		    <a href="${pageContext.request.contextPath}/postDelete?postNo=${postDetail.postNo}" class="btn btn-danger" id="deleteBtn">삭제</a>
		  </c:when>
		</c:choose>
		
        </div>
      </div>
    </div>
  </div>
</div>

<script>
  let deleteButton = document.querySelector("#deleteBtn");
  if (deleteButton) {
    deleteButton.addEventListener("click", function(e) {
      e.preventDefault();
      if (!confirm("게시글을 삭제하시겠습니까?")) {
        return;
      }
      fetch("postDelete", {
        method: "DELETE",
        headers: {
          "Content-Type": "application/json;charset=utf-8"
        },
        body: JSON.stringify({
          postNo: "${postDetail.postNo}"
        })
      })
      .then(response => response.json())
      .then(data => {
        alert(data.res_msg);
        if (data.res_code !== "400") {
          location.href = "${pageContext.request.contextPath}/postList?boardNo=${postDetail.boardNo}";
        }
      });
    });
  }
</script>
</body>
</html>
