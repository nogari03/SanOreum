package project.group;

import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;
import project.chat.ChatService;
import project.groupmedia.GroupMediaService;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.util.*;

@Slf4j
@Controller
public class GroupController{

    @Resource(name = "groupService")
    private GroupService groupService;

    @Resource(name = "groupMediaService")
    private GroupMediaService groupMediaService;

    @Resource(name = "chatService")
    private ChatService chatService;

    @GetMapping(value = "/group/main.do")
    public String goMain1(){
        return "main";
    }

    @PostMapping(value = "/group/insert.do", produces = "application/json")
    @ResponseBody
    public Map insertGroup(@RequestParam Map map,
                            @RequestParam(value = "file", required = false) List<MultipartFile> files,
                            HttpServletRequest request){
        Map result = new HashMap();

        try{
            groupService.insertGroup(map);
            String path = request.getSession().getServletContext().getRealPath("/");
            int groupNum = (int) map.get("groupNum");
            groupMediaService.insertGroupMedia(groupNum,files,path);

            result.put("groupNum",groupNum);
        }catch (Exception e){
            e.printStackTrace();
        }

        return result;
    }

    @GetMapping("/group/{groupNum}")
    public ModelAndView groupDetail(@PathVariable("groupNum") int groupNum, HttpServletRequest request){
        ModelAndView mav = new ModelAndView();
        String userId = (String) request.getSession().getAttribute("LOGIN");
        if(userId==null){
            mav.setViewName("redirect:/user/logInView.do"); //인터셉터 추가후 지우기
            return mav;
        }
        mav.setViewName("detail");
        Map<String,Object> map = groupService.selectGroupDetail(groupNum);
        List<Map> list = groupService.selectGroupDetailImage(groupNum);

        String sessionIdImage = groupService.selectSessionIdImage(userId);

        Map checkMap = new HashMap();
        checkMap.put("userId", userId);
        checkMap.put("groupNum",groupNum);
        int favoriteResult;
        try{
            favoriteResult = groupService.checkFavoriteGroup(checkMap);                                     //좋아요 체크
        }catch (Exception e){
            favoriteResult = 0;
        }
        Map userGradeResult = groupService.selectWaiting(checkMap);

        for(int i=0;i<list.size();i++){
            map.put("image"+i , list.get(i).get("STOREDFILENAME"));
        }


        List recommendResult = groupService.recommendGroup(map);

        mav.addObject("group",map);
        mav.addObject("sessionIdImage",sessionIdImage);
        mav.addObject("favoriteResult",favoriteResult);
        mav.addObject("userGradeResult",userGradeResult);
        mav.addObject("recommendResult",recommendResult);
        return mav;
    }

    @PostMapping("/group/join.do")
    @ResponseBody
    public Map joinGroup(@RequestBody Map map){
        try{
            Map result = new HashMap();
            groupService.joinGroup(map);
            groupService.insertAlarm(map);
            int groupNum = Integer.parseInt((String) map.get("groupNum"));
            String leaderId = groupService.selectGroupLeader(groupNum);
            result.put("leaderId",leaderId);
            return result;
        } catch (Exception e){
            e.printStackTrace();
            return null;
        }
    }

    @PostMapping("/group/withdraw.do")
    @ResponseBody
    public int withdrawGroup(@RequestBody Map map){
        return groupService.withdrawGroup(map);
    }

    @PostMapping("/group/selectWaitingList.do")
    @ResponseBody
    public List selectWaitingList(@RequestBody Map map){
        return groupService.selectWaitingList(map);
    }

    // 유저 그룹 승인
    @GetMapping("/group/userAllowed.do")
    @ResponseBody
    public int userAllowed(@RequestParam("userId")String userId,
                           @RequestParam("groupNum")int groupNum,
                           @RequestParam("action")String action){
        Map map = new HashMap();
        map.put("userId", userId);
        map.put("groupNum",groupNum);
        map.put("action",action);
        int result;
        result = groupService.userAllowed(map);

        String roomId = chatService.checkExistRoom(groupNum);
        map.put("roomId",roomId);

        if(result==0){
            groupService.expiredGroup((Integer) map.get("groupNum"));
        }

        return result;
    }

    // 유저 그룹 승인 취소
    @GetMapping("/group/userDisallowed.do")
    @ResponseBody
    public int userDisallowed(@RequestParam("userId")String userId,
                              @RequestParam("groupNum")int groupNum,
                              @RequestParam("action")String action){
        Map map = new HashMap();
        map.put("userId", userId);
        map.put("groupNum", groupNum);
        map.put("action",action);
        int result = groupService.userDisallowed(map);

        return result;
    }

    //그룹 인원 만료 체크
    @GetMapping("/group/checkGroupExpired.do")
    @ResponseBody
    public int checkGroupExpired(@RequestParam("groupNum")int groupNum){
        return groupService.checkGroupExpired(groupNum);
    }

    // 그룹 좋아요 등록
    @PostMapping("/group/insertFavorite.do")
    @ResponseBody
    public int insertFavoriteGroup(@RequestBody Map map){
        return groupService.insertFavoriteGroup(map);
    }

    // 그룹 좋아요 취소
    @PostMapping("/group/deleteFavorite.do")
    @ResponseBody
    public int deleteFavoriteGroup(@RequestBody Map map){
        int result = groupService.deleteFavoriteGroup(map);
        return result;
    }


    // 그룹 댓글
    @PostMapping("/group/insertComment.do")
    @ResponseBody
    public GroupCommentVO insertCommentGroup(@RequestBody Map map){
        groupService.insertCommentGroup(map);
        return groupService.selectCommentOne((Integer) map.get("commentNum"));
    }

    @PostMapping("/group/insertSubComment.do")
    @ResponseBody
    public GroupCommentVO insertSubCommentGroup(@RequestBody Map map){
        groupService.insertCommentGroup(map);
        int parentNum = Integer.parseInt(map.get("parentNum").toString());// 다이렉트로 casting 안됨
        groupService.updateSubCommentCount(parentNum);
        return groupService.selectCommentOne((Integer) map.get("commentNum"));
    }

    @GetMapping("/group/selectCommentByGroupNum.do")
    @ResponseBody
    public List selectCommentByGroupNum(@RequestParam("groupNum") int groupNum){
        List<Map> list = groupService.selectCommentByGroupNum(groupNum);
        return list;
    }
    
    @GetMapping("/group/selectCommentByPostNum.do")
    @ResponseBody
    public List selectCommentByPostNum(@RequestParam("postNum") int postNum){
        List<Map> list = groupService.selectCommentByPostNum(postNum);
        return list;
    }

    @PostMapping("/group/sortGroup.do")
    @ResponseBody
    public List sortGroupByKeyword(@RequestBody Map map){
        return groupService.sortGroupByKeyword(map);
    }
    
    @PostMapping("/group/countSubComment.do")
    @ResponseBody
    public int countSubComment(@RequestBody Map map){
        return groupService.countSubComment(map);
    }

    @GetMapping("/group/mod/{groupNum}")
    public ModelAndView updateGroupForm(@PathVariable("groupNum")int groupNum){
        ModelAndView mav = new ModelAndView("/group/modify");

        Map map = groupService.selectGroupDetail(groupNum);
        List list = groupService.selectGroupDetailImage(groupNum);

        mav.addObject("group",map);
        mav.addObject("image",list);
        return mav;
    }

    @PostMapping("/group/update.do")
    @ResponseBody
    public int updateGroupInfo(@RequestParam Map map,
                               @RequestParam(value = "file", required = false) List<MultipartFile> files,
                               HttpServletRequest request){
        try {
            int result = 0;
            result = groupService.updateGroupInfo(map);

            int groupNum = (int) map.get("groupNum");
            String path = request.getSession().getServletContext().getRealPath("/");
            groupMediaService.updateGroupMedia(groupNum,files,path);

            return result;
        } catch (IOException e) {
            return 0;
        }
    }

    @PostMapping("/group/delete.do")
    @ResponseBody
    @Transactional
    public int deleteGroup(@RequestBody Map map){
        try{
            groupService.deleteGroup(map);
            groupMediaService.deleteGroupMedia(map);
            return 1;
        } catch (Exception e){
            e.printStackTrace();
            return 0;
        }
    }

    @PostMapping("/group/deleteComment.do")
    @ResponseBody
    public int deleteComment(@RequestBody Map map){
        try{
            groupService.deleteComment(map);
            return 1;
        } catch (Exception e){
            e.printStackTrace();
            return 0;
        }
    }

    @GetMapping("/group/result.do")
    public ModelAndView createGroupResult(@RequestParam("groupNum")String groupNum){
        ModelAndView mav = new ModelAndView("result");
        mav.addObject("groupNum",groupNum);
        return mav;
    }
}
