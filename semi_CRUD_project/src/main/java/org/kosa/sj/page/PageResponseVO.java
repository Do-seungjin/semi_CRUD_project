package org.kosa.sj.page;

import java.util.List;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class PageResponseVO<T> {
  private List<T> list; // 목록
  private int totalPage = 0; // 전체 페이지 수
  private int startPage = 0; // 페이지 네비게이션 바의 시작 페이지 번호
  private int endPage = 0; // 페이지 네비게이션 바의 마지막 페이지 번호
  private int pageNo = 0; // 현재 페이지 번호
  private int size = 10;
  private int totalCount = 0; // 전체 게시물 수

  public PageResponseVO(int pageNo, List<T> list, int totalCount, int size) {
    this.pageNo = pageNo;
    this.list = list;
    this.size = size;
    this.totalCount = totalCount;

    totalPage = (int) Math.ceil((double) totalCount / size);
    startPage = ((pageNo - 1) / 10) * 10 + 1;
    endPage = ((pageNo - 1) / 10) * 10 + 10;
    if (endPage > totalPage) {
      endPage = totalPage;
    }
  }

  public boolean isPrev() {
    return startPage != 1;
  }

  public boolean isNext() {
    return totalPage != endPage;
  }
}
