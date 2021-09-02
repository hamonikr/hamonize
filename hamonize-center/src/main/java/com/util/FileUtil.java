package com.util;

import java.io.File;
import java.io.IOException;
import java.security.SecureRandom;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import org.msgpack.core.annotations.Nullable;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import com.model.FileVO;

@Component
public class FileUtil {

    @Value("${attach.path}")
    private String filePath;
    private Logger logger = LoggerFactory.getLogger(this.getClass());

    /**
     * 파일 업로드.
     */
    public List<FileVO> saveAllFiles(Map<String, List<MultipartFile>> upfileMap)
            throws NullPointerException {

        @Nullable
        List<FileVO> filelist = new ArrayList<FileVO>();

        Iterator<Entry<String, List<MultipartFile>>> itrt = upfileMap.entrySet().iterator();

        while (itrt.hasNext()) {
            Entry<String, List<MultipartFile>> entry = itrt.next();

            String key = entry.getKey();
            List<MultipartFile> upfiles = entry.getValue();

            for (MultipartFile uploadfile : upfiles) {
                if (uploadfile.getSize() == 0) {
                    continue;
                }

                String newName = getNewName();
                String realName = key + "_" + newName;

                int index = uploadfile.getOriginalFilename().lastIndexOf(".");
                String fileExt =
                        uploadfile.getOriginalFilename().substring(index + 1).toLowerCase();
                realName += "." + fileExt;

                if (fileExt.equals("jpg") || fileExt.equals("png") || fileExt.equals("gif")
                        || fileExt.equals("jpeg") || fileExt.equals("json")) {
                    saveFile(uploadfile, filePath + "/", realName, fileExt);

                    FileVO filedo = new FileVO();
                    filedo.setFilename(realName);
                    filedo.setRealname(uploadfile.getOriginalFilename());
                    filedo.setFilesize(uploadfile.getSize());
                    filedo.setFilepath(filePath);

                    filelist.add(filedo);
                } else {
                    // filelist = null;
                    filelist = List.of();
                }
            }
        }


        return filelist;
    }

    /**
     * 파일 저장 경로 생성.
     */
    public void makeBasePath(String path) {
        File dir = new File(path);
        if (!dir.exists()) {
            dir.mkdirs();
        }
    }

    /**
     * 실제 파일 저장.
     */
    public String saveFile(MultipartFile file, String basePath, String fileName, String fileExt) {
        if (file == null || file.getName().equals("") || file.getSize() < 1) {
            return null;
        }

        makeBasePath(basePath);
        String serverFullPath = basePath + fileName;

        int index = file.getOriginalFilename().lastIndexOf(".");
        String fileTmp = file.getOriginalFilename().substring(index + 1);
        File file1 = new File(serverFullPath);

        try {
            if (fileTmp.equals(fileExt)) {
                file.transferTo(file1);
            } else {
                boolean aa = file1.delete();
                if (!aa) {
                    logger.error("fail to delete file");
                } else {
                    logger.info("success to delete file");
                }

                serverFullPath = null;
            }
        } catch (IllegalStateException ex) {
            logger.error(ex.getMessage(), ex);
        } catch (IOException e) {
            logger.error(e.getMessage(), e);
        }

        return serverFullPath;
    }

    /**
     * 날짜로 새로운 파일명 부여.
     */
    public String getNewName() {
        SecureRandom random = new SecureRandom(); // Compliant for security-sensitive use cases

        SimpleDateFormat ft = new SimpleDateFormat("yyyyMMddhhmmssSSS");
        return ft.format(new Date()) + random.nextInt(11);
    }

    public String getFileExtension(String filename) {
        Integer mid = filename.lastIndexOf(".");
        return filename.substring(mid, filename.length());
    }

    public String getRealPath(String path, String filename) {
        return path + filename.substring(0, 4) + "/";
    }
}
