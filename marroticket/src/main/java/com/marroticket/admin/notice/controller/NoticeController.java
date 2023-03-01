package com.marroticket.admin.notice.controller;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.marroticket.admin.notice.domain.NoticeVO;
import com.marroticket.admin.notice.service.NoticeService;
import com.marroticket.common.domain.PageRequest;
import com.marroticket.common.domain.Pagination;

@PreAuthorize("hasRole('ROLE_ADMIN')")
@Controller
@RequestMapping("/notice")
@MapperScan(basePackages = "com.marroticket.mapper")
public class NoticeController {

	@Autowired
	private NoticeService service;

	// 공지사항 등록 페이지
	@RequestMapping(value = "/noticeRegister", method = RequestMethod.GET)
	public String registerForm(Model model) throws Exception {
		System.out.println("공지사항 등록");
		NoticeVO noticeVO = new NoticeVO();

		model.addAttribute(noticeVO);
		return "admin.notice.noticeRegister";
	}

	// 공지사항 등록 처리
	@RequestMapping(value = "/noticeRegister", method = RequestMethod.POST)

	public String register(NoticeVO noticeVO, RedirectAttributes rttr) throws Exception {
		service.register(noticeVO);

		rttr.addFlashAttribute("msg", "SUCCESS");
		System.out.println("공지사항 등록 처리");

		return "redirect:/notice/noticeList?accept=admin";
	}

	// 공지사항 목록 페이지
	@PreAuthorize("hasRole('ROLE_TMEMBER') or hasRole('ROLE_ADMIN')")
	@RequestMapping(value = "/noticeList", method = RequestMethod.GET)
	public String list(@ModelAttribute("pgrq") PageRequest pageRequest, Model model, String accept) throws Exception {

		model.addAttribute("noticeList", service.list(pageRequest));

		String url = "notice.noticeList";
		System.out.println("공지사항 목록");

		// 페이징 네비게이션 정보를 뷰에 전달한다.
		Pagination pagination = new Pagination();
		pagination.setPageRequest(pageRequest);
		pagination.setTotalCount(service.count());
		model.addAttribute("pagination", pagination);
		System.out.println("공지사항 목록");

		if ("admin".equals(accept)) {
			// model.addAttribute("accept","tmember");
		 url = "admin.notice.noticeList";
		return url;
		}

		return url;
	}

	// 공지사항 상세 페이지
	@PreAuthorize("hasRole('ROLE_TMEMBER') or hasRole('ROLE_ADMIN')")
	@RequestMapping(value = "/noticeRead", method = RequestMethod.GET)
	public String read(int noticeNo, @ModelAttribute("pgrq") PageRequest pageRequest, Model model, String accept)
			throws Exception {

		model.addAttribute(service.read(noticeNo));

		String url = "notice.noticeRead";
		System.out.println("공지사항 상세");

		if ("admin".equals(accept)) {
			url = "admin.notice.noticeRead";
		}

		return url;

	}

	// 공지사항 수정 페이지
	@RequestMapping(value = "/noticeModify", method = RequestMethod.GET)
	public String modifyForm(int noticeNo, @ModelAttribute("pgrq") PageRequest pageRequest, Model model)
			throws Exception {

		// 조회한 게시글 상세 정보를 뷰에 전달한다.
		model.addAttribute(service.read(noticeNo));
		System.out.println("공지사항 수정");
		return "notice/modify/noticeModify";
	}

	// 공지사항 수정 처리
	@RequestMapping(value = "/noticeModify", method = RequestMethod.POST)
	public String modify(NoticeVO noticeVO, PageRequest pageRequest, RedirectAttributes rttr) throws Exception {
		service.modify(noticeVO);

		// RedirectAttributes 객체에 일회성 데이터를 지정하여 전달한다.
		rttr.addAttribute("page", pageRequest.getPage());
		rttr.addAttribute("sizePerPage", pageRequest.getSizePerPage());
		rttr.addFlashAttribute("msg", "SUCCESS");
		System.out.println("공지사항 수정처리");

		return "redirect:/notice/noticeList?accept=admin";
	}

	// 공지사항 삭제 처리

	@RequestMapping(value = "/remove", method = RequestMethod.POST)
	public String remove(int noticeNo, PageRequest pageRequest, RedirectAttributes rttr) throws Exception {
		service.remove(noticeNo);

		// RedirectAttributes 객체에 일회성 데이터를 지정하여 전달한다.
		rttr.addAttribute("page", pageRequest.getPage());
		rttr.addAttribute("sizePerPage", pageRequest.getSizePerPage());
		rttr.addFlashAttribute("msg", "SUCCESS");
		System.out.println("공지사항 삭제처리");

		return "redirect:/notice/noticeList?accept=admin";
	}
}