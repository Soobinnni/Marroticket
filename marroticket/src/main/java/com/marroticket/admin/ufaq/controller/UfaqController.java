package com.marroticket.admin.ufaq.controller;

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

import com.marroticket.admin.ufaq.domain.UfaqVO;
import com.marroticket.admin.ufaq.service.UfaqService;
import com.marroticket.common.domain.PageRequest;
import com.marroticket.common.domain.Pagination;

@PreAuthorize("hasRole('ROLE_ADMIN')")
@Controller
@RequestMapping("/ufaq")
@MapperScan(basePackages = "com.marroticket.mapper")
public class UfaqController {

	@Autowired
	private UfaqService service;

	// 극단 FAQ 등록 페이지
	@RequestMapping(value = "/ufaqRegister", method = RequestMethod.GET)
	public String registerForm(Model model, Authentication authentication) throws Exception {
		UfaqVO ufaqVO = new UfaqVO();
		model.addAttribute(ufaqVO);
		
		return "admin.ufaq.ufaqRegister";
	}

	// 극단 FAQ 등록처리
	@RequestMapping(value = "/ufaqRegister", method = RequestMethod.POST)
	public String register(UfaqVO ufaqVO, RedirectAttributes rttr) throws Exception {
		service.register(ufaqVO);

		rttr.addFlashAttribute("msg", "SUCCESS");
		return "redirect:/ufaq/ufaqList?accept=admin";
	}

	// 페이징 요청 정보를 매개변수로 받고 다시 뷰에 전달한다.
	//@PreAuthorize("hasRole(두개주기)") // 비회원도 봐야함
	@RequestMapping(value = "/ufaqList", method = RequestMethod.GET)
	@PreAuthorize("isAnonymous() or hasRole('ROLE_UMEMBER') or hasRole('ROLE_ADMIN')")
	public String list(PageRequest pageRequest, Model model, String accept) throws Exception {

		String url = "ufaq.ufaqList";
		System.out.println("일반회원 FAQ 목록");

		if ("admin".equals(accept)) {
			url = "admin.ufaq.ufaqList";
		}
		
		// 페이징 네비게이션 정보를 뷰에 전달한다.
		Pagination pagination = new Pagination();
		pagination.setPageRequest(pageRequest);
		pagination.setTotalCount(service.count());
		model.addAttribute("pagination", pagination);
		
		// 뷰에 페이징 처리를 한 게시글 목록을 전달한다.
		model.addAttribute("ufaqList", service.list(pageRequest));
		
		return url;
	}

	// 게시글 상세 페이지, 페이징 요청 정보를 매개변수로 받고 다시 뷰에 전달한다.
	@PreAuthorize("isAnonymous() or hasRole('ROLE_UMEMBER') or hasRole('ROLE_ADMIN')")
	@RequestMapping(value = "/ufaqRead", method = RequestMethod.GET)
	public String read(int ufaqNo, @ModelAttribute("pgrq") PageRequest pageRequest, Model model, String accept) throws Exception {
		String url = "ufaq.ufaqRead";
		System.out.println("일반회원 FAQ 상세");
		
		if ("admin".equals(accept)) {
			url = "admin.ufaq.ufaqRead";
		}
		
		// 조회한 게시글 상세 정보를 뷰에 전달한다
		model.addAttribute(service.read(ufaqNo));
		
		return url;
	}

	// 게시글 수정 페이지, 페이징 요청 정보를 매개변수로 받고 다시 뷰에 전달한다.
	@RequestMapping(value = "/ufaqModify", method = RequestMethod.GET)
	public String modifyForm(int ufaqNo, @ModelAttribute("pgrq") PageRequest pageRequest, Model model) throws Exception {

		// 조회한 게시글 상세 정보를 뷰에 전달한다
		model.addAttribute(service.read(ufaqNo));
		return "admin.ufaq.ufaqModify";
	}

	// 게시글 수정 처리, 페이징 요청 정보를 매개변수로 받고 다시 뷰에 전달한다.
	@RequestMapping(value = "/ufaqModify", method = RequestMethod.POST)
	public String modify(UfaqVO ufaqVO, PageRequest pageRequest, RedirectAttributes rttr) throws Exception {
		service.modify(ufaqVO);

		// RedirectAttributes 객체에 일회성 데이터를 지정하여 전달한다.
		rttr.addAttribute("page", pageRequest.getPage());
		rttr.addAttribute("sizePerPage", pageRequest.getSizePerPage());
		rttr.addFlashAttribute("msg", "SUCCESS");

		return "redirect:/ufaq/ufaqList?accept=admin";
	}

	// 게시글 삭제 처리, 페이징 요청 정보를 매개변수로 받고 다시 뷰에 전달한다.
	@RequestMapping(value = "/remove", method = RequestMethod.POST)
	public String remove(int ufaqNo, PageRequest pageRequest, RedirectAttributes rttr) throws Exception {
		service.remove(ufaqNo);

		// RedirectAttributes 객체에 일회성 데이터를 지정하여 전달한다.
		rttr.addAttribute("page", pageRequest.getPage());
		rttr.addAttribute("sizePerPage", pageRequest.getSizePerPage());
		rttr.addFlashAttribute("msg", "SUCCESS");

		return "redirect:/ufaq/ufaqList?accept=admin";

	}

}