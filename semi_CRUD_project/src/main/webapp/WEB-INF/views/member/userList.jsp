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

  .memberList-table {
    width: 800px;
    margin: 40px auto;
    border-collapse: collapse;
    background-color: white;
    border-radius: 8px;
    overflow: hidden;
    box-shadow: 0 2px 6px rgba(0, 0, 0, 0.1);
  }

  .memberList-table th,
  .memberList-table td {
    padding: 12px;
    border: 1px solid #dee2e6;
    text-align: center;
  }

  .memberList-table caption {
    caption-side: top;
    font-size: 22px;
    font-weight: bold;
    padding: 15px;
  }

  .clickable-row:hover {
    background-color: #f1f1f1;
    cursor: pointer;
  }

  .controls {
    width: 800px;
    margin: 30px auto 10px;
    display: flex;
    justify-content: space-between;
    align-items: center;
  }

  .pagination-area {
    width: 800px;
    margin: 20px auto;
    text-align: center;
  }

  .pagination-area a {
    margin: 0 5px;
    text-decoration: none;
    color: #0d6efd;
  }

  .pagination-area a:hover {
    text-decoration: underline;
  }
</style>

<meta charset="UTF-8">
<title>회원 목록 조회</title>
</head>
<body>
<%@ include file="../include/header.jsp"%>

<div class="controls">
  <div>
    건수 : 
    <select name="size" id="size" class="form-select d-inline-block w-auto">
      <c:forTokens items="10,20,50,100" delims="," var="size">
        <option value="${size}" ${pageResponse.size == size ? 'selected' : ''}>${size}</option>
      </c:forTokens>
    </select>
  </div>
  <form action="userList" class="d-flex gap-2">
    <input type="text" name="searchValue" id="searchValue" value='${param.searchValue}' class="form-control" placeholder="검색어 입력">
    <input type="submit" value="검색" class="btn btn-primary btn-sm">
  </form>
</div>

<table class="memberList-table">
  <caption>회원 목록</caption>
  <thead class="table-light">
    <tr>
      <th></th>
      <th>아이디</th>
      <th>이름</th>
      <th>등록일</th>
      <th>로그인 잠금</th>
    </tr>
  </thead>
  <tbody>
    <c:if test="${empty pageResponse.list}">
      <tr>
        <td colspan="5">존재하는 회원 정보가 없습니다</td>
      </tr>
    </c:if>
    <c:forEach items="${pageResponse.list}" var="item" varStatus="status">
      <tr class="clickable-row" data-href="${pageContext.request.contextPath}/detailView?userid=${item.userId}">
        <td>${status.count + (pageResponse.pageNo - 1)*pageResponse.size}</td>
        <td>${item.userId}</td>
        <td>${item.userName}</td>
        <td><fmt:formatDate value="${item.userRegDate}" pattern="yyyy년 MM월 dd일" /></td>
        <td>
          <c:choose>
            <c:when test="${item.failCnt == 0}">
              해당없음
            </c:when>
            <c:when test="${item.failCnt >= 1 && item.failCnt < 5}">
              ${item.failCnt}
            </c:when>
            <c:when test="${item.failCnt == 5}">
              잠금 중
            </c:when>
            <c:otherwise>
              -
            </c:otherwise>
          </c:choose>
        </td>
      </tr>
    </c:forEach>
  </tbody>
</table>

<div class="pagination-area">
  <c:if test="${pageResponse.prev}">
    <a href="userList?pageNo=${pageResponse.startPage-1}&size=${pageResponse.size}&searchValue=${param.searchValue}">&lt;</a>
  </c:if>

  <c:forEach begin="${pageResponse.startPage}" end="${pageResponse.endPage}" var="pageNo">
    <a href="userList?pageNo=${pageNo}&size=${pageResponse.size}&searchValue=${param.searchValue}">
      <c:choose>
        <c:when test="${pageNo == pageResponse.pageNo}">
          <b>${pageNo}</b>
        </c:when>
        <c:otherwise>${pageNo}</c:otherwise>
      </c:choose>
    </a>
  </c:forEach>

  <c:if test="${pageResponse.next}">
    <a href="userList?pageNo=${pageResponse.endPage+1}&size=${pageResponse.size}&searchValue=${param.searchValue}">&gt;</a>
  </c:if>
</div>

<script>
  const size = document.querySelector("#size");
  size.addEventListener("change", e => {
    location = "userList?pageNo=1&size=" + size.value;
  });

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
