package project.board;

import java.util.List;
import java.util.Map;

public interface BoardService {

    List selectBoard(Map map);
    int selectBoardAllCount(String csPostType);
    List selectBoardDetail(int csPostNum);
}
