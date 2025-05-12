<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<style>
  body {
    background-color: #f8f9fa;
    font-family: sans-serif;
  }

  .board-container {
    max-width: 800px;
    margin: 50px auto;
    background-color: white;
    padding: 30px;
    border-radius: 10px;
    box-shadow: 0 2px 10px rgba(0,0,0,0.1);
  }

  .board-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 20px;
  }

  .board-header h3 {
    margin: 0;
    font-weight: bold;
  }

  .clickable-row:hover {
    background-color: #f1f1f1;
    cursor: pointer;
  }
</style>

<meta charset="UTF-8">
<title>게시물 목록</title>
</head>
<body>
<%@ include file="../include/header.jsp"%>

<div class="container-fluid px-4">
  <div class="board-container mx-auto" style="max-width: 1200px;">
    <div class="board-header">
      <h3>게시물 목록</h3>
      <c:if test="${boardNo != 2 || (boardNo == 2 && sessionScope.member.isManager eq 'Y')}">
      	<button id="postBtn" class="btn btn-primary">작성하기</button>
      </c:if>
    </div>

    <div class="d-flex justify-content-between align-items-center mb-3">
      <div>
        건수 :
        <select name="size" id="size" class="form-select d-inline-block w-auto">
          <c:forTokens items="10,20,50,100" delims="," var="size">
            <option value="${size}" ${pageResponse.size == size ? 'selected' : ''}>${size}</option>
          </c:forTokens>
        </select>
      </div>
    </div>

    <form action="postList" class="mb-3">
      <input type="hidden" name="boardNo" value="${boardNo}"/>
      <div class="input-group">
        <input type="text" name="searchValue" id="searchValue" value='${param.searchValue}' class="form-control" placeholder="검색어 입력">
        <button type="submit" class="btn btn-outline-secondary">검색</button>
      </div>
    </form>

    <table class="table table-bordered text-center">
      <thead class="table-light">
        <tr>
          <th>제목</th>
          <th>작성자</th>
          <th>작성일</th>
          <th>조회수</th>
        </tr>
      </thead>
      <tbody>
        <c:if test="${empty pageResponse.list}">
          <tr>
            <td colspan="4">존재하는 게시물이 없습니다</td>
          </tr>
        </c:if>
        <c:forEach items="${pageResponse.list}" var="item" varStatus="status">
          <tr class="clickable-row" data-href="${pageContext.request.contextPath}/postDetailView?postno=${item.postNo}">
            <td>${item.postTitle}</td>
            <td>${item.userName}</td>
            <td><fmt:formatDate value="${item.postRegDate}" pattern="yyyy년 MM월 dd일" /></td>
            <td>${item.viewCnt}</td>
          </tr>
        </c:forEach>
      </tbody>
    </table>

    <div class="text-center mt-4">
      <c:if test="${pageResponse.prev}">
        <a class="btn btn-outline-secondary btn-sm" href="postList?pageNo=${pageResponse.startPage-1}&size=${pageResponse.size}&searchValue=${param.searchValue}&boardNo=${boardNo}">&lt;</a>
      </c:if>

      <c:forEach begin="${pageResponse.startPage}" end="${pageResponse.endPage}" var="pageNo">
        <a class="btn btn-sm ${pageNo == pageResponse.pageNo ? 'btn-primary' : 'btn-outline-primary'} mx-1"
           href="postList?pageNo=${pageNo}&size=${pageResponse.size}&searchValue=${param.searchValue}&boardNo=${boardNo}">
          ${pageNo}
        </a>
      </c:forEach>

      <c:if test="${pageResponse.next}">
        <a class="btn btn-outline-secondary btn-sm" href="postList?pageNo=${pageResponse.endPage+1}&size=${pageResponse.size}&searchValue=${param.searchValue}&boardNo=${boardNo}">&gt;</a>
      </c:if>
    </div>
  </div>
</div>

<script type="text/javascript">
  const size = document.querySelector("#size");
  size.addEventListener("change", e => {
    location = "postList?pageNo=1&boardNo=${boardNo}&size=" + size.value;
  });
</script>

<script>
  document.querySelector("#postBtn").addEventListener("click", function () {
    const boardNo = '${boardNo}';
    const userNo = '${sessionScope.member.userNo}';

    fetch("postRegisterForm?userNo=" + userNo + "&boardNo=" + boardNo)
      .then(response => response.json())
      .then(data => {
        if (data.res_code === "400") {
          alert(data.res_msg);
          location.href = "loginForm";
        } else {
          location.href = "postForm?userNo=" + data.userNo + "&boardNo=" + data.boardNo;
        }
      });
  });
</script>

<script>
  document.addEventListener("DOMContentLoaded", function () {
    const rows = document.querySelectorAll(".clickable-row");
    rows.forEach(row => {
      row.addEventListener("click", function () {
        window.location.href = row.dataset.href;
      });
    });
  });
</script>
</body>
</html>
