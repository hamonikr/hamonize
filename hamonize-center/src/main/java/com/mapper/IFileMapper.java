package com.mapper;

import java.util.List;
import com.model.FileVo;

public interface IFileMapper {
    
    public List <FileVo> getFiles();
    public FileVo getFile(String type);
    public int saveFile(FileVo vo);
    public int deleteFile(FileVo vo);

}
