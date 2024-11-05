// eslint-disable-next-line import/no-unresolved
const multer = require('multer');
const path = require('path');

// Set storage engine
const storage = multer.diskStorage({
  destination: path.join(__dirname, '../../uploads/avatars'),
  filename(req, file, cb) {
    cb(null, `${file.fieldname}-${Date.now()}${path.extname(file.originalname)}`);
  },
});

// Initialize upload
const upload = multer({
  storage,
  limits: { fileSize: 10000000 }, // Limit file size to 10MB
  fileFilter(req, file, cb) {
    // eslint-disable-next-line no-use-before-define
    checkFileType(file, cb);
  },
}).single('avatar'); // 'avatar' is the name of the field in the form

// Check file type
function checkFileType(file, cb) {
  const filetypes = /jpeg|jpg|png|gif/;
  const extname = filetypes.test(path.extname(file.originalname).toLowerCase());
  const mimetype = filetypes.test(file.mimetype);

  if (extname && mimetype) {
    return cb(null, true);
  }
  cb('Error: Images Only!');
}

module.exports = upload;
