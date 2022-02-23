package com.service;

import org.springframework.stereotype.Service;

@Service
public class MainService {

	// @Autowired
	// private IMainMapper mMpper;
	// private Logger logger = LoggerFactory.getLogger(this.getClass());

	// public List<Map<String, Object>> pcListInfo(Map<String, Object> params) {

	// 	List<Map<String, Object>> list = new LinkedList<Map<String, Object>>();
	// 	List<Map<String, Object>> ulist = new LinkedList<Map<String, Object>>();
	// 	List<PcDataVo> influxListData = new LinkedList<PcDataVo>();
	// 	try {
	// 		list = mMpper.pcTotalSidoCount();
	// 		ulist = mMpper.pcUseSidoCount();

	// 		if (list.size() > 0) {
	// 			int cnt = 0;
	// 			for (Map<String, Object> uuid : list) {
	// 				for (Map<String, Object> useuuid : ulist) {
	// 					if (uuid.get("sgb_pc_uuid") != null) {
	// 						if (((String) uuid.get("sgb_pc_uuid"))
	// 								.matches((String) useuuid.get("sgb_pc_uuid"))) {
	// 							list.get(cnt).put("sgb_pc_status", "true");
	// 						} else {
	// 							// influxListData.get(j).setStatus(false);
	// 						}
	// 					}
	// 				}
	// 				cnt++;
	// 			}
	// 		} else {
	// 			influxListData.clear();
	// 		}
	// 	} catch (Exception e) {
	// 		logger.error(e.getMessage(), e);
	// 	}
	// 	return list;
	// }

	// public List<Map<String, Object>> serverListInfo(Map<String, Object> params) {

	// List<Map<String, Object>> list = new LinkedList<Map<String, Object>>();
	// List<Map<String, Object>> ulist = new LinkedList<Map<String, Object>>();
	// List<PcDataVo> influxListData = new LinkedList<PcDataVo>();
	// try {
	// list = mMpper.serverTotalSidoCount();
	// ulist = mMpper.serverUseSidoCount();
	// //influxListData = mService.influxInfo();
	// if (list.size() > 0) {
	// int cnt = 0;
	// for (Map<String, Object> uuid : list) {
	// for (Map<String, Object> useuuid : ulist) {
	// if(uuid.get("sgb_pc_uuid") != null) {
	// if (((String) uuid.get("sgb_pc_uuid")).matches((String)useuuid.get("sgb_pc_uuid"))) {
	// //influxListData.get(j).setStatus(true);
	// list.get(cnt).put("sgb_pc_status", "true");
	// } else {
	// //influxListData.get(j).setStatus(false);
	// }
	// }
	// }
	// cnt++;
	// }
	// } else {
	// influxListData.clear();
	// }
	// } catch (Exception e) {
	// logger.error(e.getMessage(), e);
	// }
	// return list;
	// }

}
