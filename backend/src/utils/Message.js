const registerSuccess = 'Đăng ký thành công';
const loginSuccess = 'Đăng nhập thành công';
const logoutSuccess = 'Đăng xuất thành công';
const deactivatedAccount = 'Tài khoản bị tạm khóa';
const phoneVerify = 'Số điện thoại hoặc mật khẩu không đúng';

const ok = 'ok';
const success = 'Thành công';
const uploaded = 'Đã đăng tải';
const notFound = 'Không tìm thấy';
const deleted = 'Đã xoá';
const updated = 'Đã cập nhật';

const journeyMsg = {
  created: 'tạo hành trình thành công',
  nameExisted: 'hành trình đã tồn tại',
  name: 'không được để trống tên',
  notFound: 'hành trình này không tồn tại',
  description: 'không được để trống miêu tả',
  updated: 'cập nhập thành công',
  deleted: 'xoá thành công',
};

const visitMsg = {
  created: 'tạo điểm thăm thành công',
  name: 'không được để trống tên',
  nameExisted: 'điểm thăm này đã tồn tại',
  notFound: 'điểm thăm này không tồn tại',
  deleted: 'Xóa điểm thăm thành công',
};

const locationMsg = {
  created: 'tạo điểm cố định thành công',
  name: 'không được để trống tên',
  nameExisted: 'điểm cố định này đã tồn tại',
  notFound: 'điểm cố định này không tồn tại',
  deleted: 'Xóa điểm cố định thành công',
  updated: 'Cập nhật location thành công',
};

const positionMsg = {
  created: 'tạo vị trí người dùng thành công',
  name: 'không được để trống tên',
  notFound: 'vị trí người dùng không tồn tại',
  deleted: 'Xóa vị trí người dùng thành công',
  updated: 'Cập nhật position thành công',
};

const cityMsg = {
  created: 'tạo thành phố thành công',
  name: 'không được để trống tên',
  nameExisted: 'thành phố này đã tồn tại',
  notFound: 'thành phố này không tồn tại',
  deleted: 'Xóa thành phố thành công',
  updated: 'Cập nhật thành phố thành công',
};

const locationCategoryMsg = {
  created: 'tạo danh mục thành công',
  name: 'không được để trống tên',
  nameExisted: 'danh mục này đã tồn tại',
  notFound: 'danh mục này không tồn tại',
  deleted: 'Xóa danh mục thành công',
  updated: 'Cập nhật danh mục thành công',
};

const pictureMsg = {
  created: 'tạo ảnh thành công ',
  nameExisted: 'ảnh đã tồn tại',
  notFound: 'ảnh không tồn tại',
  deleted: 'Xóa ảnh thăm thành công',
};

const userMsg = {
  notFound: 'Không tồn tại user này',
  emailAlreadyTaken: 'Email này đã được dùng',
  notMatchingCurrentPassword: 'Không thể thay đổi mật khẩu do nhập sai mật khẩu cũ',
  updated: 'Cập nhật user thành công',
  deleted: 'Xóa user thành công',
  invalidOTP: 'Mã OTP không hợp lệ',
  successfullyCreatedOTP: 'Tạo OTP thành công',
  successfullyChangedPassword: 'Đổi password thành công',
  expiredOTP: 'OTP đã hết hạn',
};

const validationMsg = {
  nameRequired: 'Yêu cầu nhập tên',
  startTimeRequire: 'Yêu cầu nhập thời gian bắt đầu',
  endTimeRequire: 'Yêu cầu nhập thời gian kết thúc',
  timeMustBePositiveIntegerNumber: 'Giờ hoặc phút phải là số nguyên dương',
  latitudeRequired: 'Không có thông tin vị trí',
  longtitudeRequired: 'Không có thông tin vị trí',
};

const uploadMsg = {
  exceedFileUploadSize: 'Vượt quá dung lượng upload tối đa',
  invalidFileExtension: 'Định dạng file không hợp lệ',
  failedUpload: 'Upload file thất bại',
  exceedFileUploadSize5MB: 'Vui lòng up ảnh với dung lượng tối đa chỉ được 5Mb',
};

module.exports = {
  registerSuccess,
  loginSuccess,
  logoutSuccess,
  deactivatedAccount,
  phoneVerify,
  ok,
  success,
  deleted,
  updated,
  uploaded,
  notFound,
  journeyMsg,
  visitMsg,
  pictureMsg,
  userMsg,
  validationMsg,
  uploadMsg,
  locationMsg,
  positionMsg,
  cityMsg,
  locationCategoryMsg,
};
