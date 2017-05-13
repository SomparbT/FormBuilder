package formbuilder.model.uploadfile.dao;

import formbuilder.model.uploadfile.UploadFile;

public interface UploadFileDao {
	UploadFile save(UploadFile uploadFile);

	void deleteFile(String fileName);

}
