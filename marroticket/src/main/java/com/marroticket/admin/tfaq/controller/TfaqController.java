package com.marroticket.admin.tfaq.controller;

import java.util.List;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.marroticket.admin.tfaq.domain.TfaqVO;
import com.marroticket.admin.tfaq.service.TfaqService;
import com.marroticket.common.domain.PageRequest;
import com.marroticket.common.domain.Pagination;

@Controller
@RequestMapping("/tfaq")
@MapperScan(basePackages = "com.marroticket.mapper")
public class TfaqController {

	@Autowired
	private TfaqService service;

	// 극단 FAQ 등록 페이지
	@RequestMapping(value = "/tfaqRegister", method = RequestMethod.GET)
	public void registerForm(Model model, Authentication authentication) throws Exception {
		TfaqVO tfaqVO = new TfaqVO();
		model.addAttribute(tfaqVO);
	}

	// 극단 FAQ 등록처리
	@RequestMapping(value = "/tfaqRegister", method = RequestMethod.POST)
	public String register(TfaqVO tfaqVO, RedirectAttributes rttr) throws Exception {
		service.register(tfaqVO);

		rttr.addFlashAttribute("msg", "SUCCESS");
		return "redirect:/tfaq/tfaqList";
	}

	// 극단 FAQ 목록 페이지

	/*
	 * @RequestMapping(value = "/tfaqList", method = RequestMethod.GET) public
	 * String list(Model model) throws Exception {
	 * 
	 * List<TfaqVO> list = service.list(); System.out.println(list.toString());
	 * 
	 * model.addAttribute("tfaqList", service.list());
	 * System.out.println("극단 FAQ 목록"); return "admin.tfaq.tfaqList"; }
	 */

	// 페이징 요청 정보를 매개변수로 받고 다시 뷰에 전달한다.

	//@PreAuthorize("hasRole(두개주기)")
	@RequestMapping(value = "/tfaqList", method = RequestMethod.GET)
	public String list(PageRequest pageRequest, Model model, String accept) throws Exception {

		String url = "tfaq.tfaqList";
		System.out.println("극단회원 FAQ 목록");
		
		if ("admin".equals(accept)) {
			// model.addAttribute("accept","tmember");
			//url = "tfaq.tfaqList";
			url = "admin.tfaq.tfaqList";
		}
		
		// 페이징 네비게이션 정보를 뷰에 전달한다.
		Pagination pagination = new Pagination();
		pagination.setPageRequest(pageRequest);
		pagination.setTotalCount(service.count());
		model.addAttribute("pagination", pagination);
		//}
	
		// 뷰에 페이징 처리를 한 게시글 목록을 전달한다.
		model.addAttribute("tfaqList", service.list(pageRequest));
		
		return url;
	}

	// 게시글 상세 페이지, 페이징 요청 정보를 매개변수로 받고 다시 뷰에 전달한다.
	@RequestMapping(value = "/tfaqRead", method = RequestMethod.GET)
	public void read(int tfaqNo, @ModelAttribute("pgrq") PageRequest pageRequest, Model model) throws Exception {

		// 조회한 게시글 상세 정보를 뷰에 전달한다
		model.addAttribute(service.read(tfaqNo));
	}

	// 게시글 수정 페이지, 페이징 요청 정보를 매개변수로 받고 다시 뷰에 전달한다.
	@RequestMapping(value = "/tfaqModify", method = RequestMethod.GET)
	public void modifyForm(int tfaqNo, @ModelAttribute("pgrq") PageRequest pageRequest, Model model) throws Exception {

		// 조회한 게시글 상세 정보를 뷰에 전달한다
		model.addAttribute(service.read(tfaqNo));
	}

	// 게시글 수정 처리, 페이징 요청 정보를 매개변수로 받고 다시 뷰에 전달한다.
	@RequestMapping(value = "/tfaqModify", method = RequestMethod.POST)
	public String modify(TfaqVO tfaqVO, PageRequest pageRequest, RedirectAttributes rttr) throws Exception {
		service.modify(tfaqVO);

		// RedirectAttributes 객체에 일회성 데이터를 지정하여 전달한다.
		rttr.addAttribute("page", pageRequest.getPage());
		rttr.addAttribute("sizePerPage", pageRequest.getSizePerPage());
		rttr.addFlashAttribute("msg", "SUCCESS");

		return "redirect:/tfaq/tfaqList";
	}

	/*
	// 게시글 삭제 처리, 페이징 요청 정보를 매개변수로 받고 다시 뷰에 전달한다.
	@RequestMapping(value = "/remove", method = RequestMethod.POST)
	public String remove(int tfaqNo, PageRequest pageRequest, RedirectAttributes rttr) throws Exception {
		service.remove(tfaqNo);

		// RedirectAttributes 객체에 일회성 데이터를 지정하여 전달한다.
		rttr.addAttribute("page", pageRequest.getPage());
		rttr.addAttribute("sizePerPage", pageRequest.getSizePerPage());
		rttr.addFlashAttribute("msg", "SUCCESS");
		return "redirect:/tfaq/tfaqList";
	}
	*/
}