package tw.com.sbi.vo;

import java.io.Serializable;
import java.sql.Timestamp;

public class CaseCompetitionVO implements Serializable {

	private static final long serialVersionUID = 1L;

	private String competition_id;
	private String case_id;
	private String group_id;
	private String bcircle_id;
	private String industry;
	private Integer competition_no;
	private String competition_name;
	private Integer evaluate_no;
	private String evaluate;
	private String evaluate_1_no;
	private String evaluate_1;
	private String ending_time;
	private String result;
	private Integer isfinish;

	private String city_city_name;
	private String city_country_id;
	private String country_country_name;
	private String bcircle_bcircle_name;

	private String v_decision_proposal;

	private String status;

	public String getV_decision_proposal() {
		return v_decision_proposal;
	}

	public void setV_decision_proposal(String v_decision_proposal) {
		this.v_decision_proposal = v_decision_proposal;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getCompetition_id() {
		return competition_id;
	}

	public void setCompetition_id(String competition_id) {
		this.competition_id = competition_id;
	}

	public String getCase_id() {
		return case_id;
	}

	public void setCase_id(String case_id) {
		this.case_id = case_id;
	}

	public String getGroup_id() {
		return group_id;
	}

	public void setGroup_id(String group_id) {
		this.group_id = group_id;
	}

	public String getBcircle_id() {
		return bcircle_id;
	}

	public void setBcircle_id(String bcircle_id) {
		this.bcircle_id = bcircle_id;
	}

	public Integer getCompetition_no() {
		return competition_no;
	}

	public void setCompetition_no(Integer competition_no) {
		this.competition_no = competition_no;
	}

	public String getCompetition_name() {
		return competition_name;
	}

	public void setCompetition_name(String competition_name) {
		this.competition_name = competition_name;
	}

	public Integer getEvaluate_no() {
		return evaluate_no;
	}

	public void setEvaluate_no(Integer evaluate_no) {
		this.evaluate_no = evaluate_no;
	}

	public String getEvaluate() {
		return evaluate;
	}

	public void setEvaluate(String evaluate) {
		this.evaluate = evaluate;
	}

	public String getEvaluate_1_no() {
		return evaluate_1_no;
	}

	public void setEvaluate_1_no(String evaluate_1_no) {
		this.evaluate_1_no = evaluate_1_no;
	}

	public String getEvaluate_1() {
		return evaluate_1;
	}

	public void setEvaluate_1(String evaluate_1) {
		this.evaluate_1 = evaluate_1;
	}

	public String getEnding_time() {
		return ending_time;
	}

	public void setEnding_time(String ending_time) {
		this.ending_time = ending_time;
	}

	public String getResult() {
		return result;
	}

	public void setResult(String result) {
		this.result = result;
	}

	public Integer getIsfinish() {
		return isfinish;
	}

	public void setIsfinish(Integer isfinish) {
		this.isfinish = isfinish;
	}

	public static long getSerialversionuid() {
		return serialVersionUID;
	}

	public String getCity_city_name() {
		return city_city_name;
	}

	public void setCity_city_name(String city_city_name) {
		this.city_city_name = city_city_name;
	}

	public String getCity_country_id() {
		return city_country_id;
	}

	public void setCity_country_id(String city_country_id) {
		this.city_country_id = city_country_id;
	}

	public String getCountry_country_name() {
		return country_country_name;
	}

	public void setCountry_country_name(String country_country_name) {
		this.country_country_name = country_country_name;
	}

	public String getBcircle_bcircle_name() {
		return bcircle_bcircle_name;
	}

	public void setBcircle_bcircle_name(String bcircle_bcircle_name) {
		this.bcircle_bcircle_name = bcircle_bcircle_name;
	}

	public String getIndustry() {
		return industry;
	}

	public void setIndustry(String industry) {
		this.industry = industry;
	}

}
