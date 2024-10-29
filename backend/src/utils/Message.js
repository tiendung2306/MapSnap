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
  update: 'cập nhập thành công',
  delete: 'xoá thành công',
};

const visitMsg = {
  created: 'tạo điểm thăm thành công',
  name: 'không được để trống tên',
  notFound: 'điểm thăm này không tồn tại',
};

const pictureMsg = {
  created: 'tạo ảnh thành công ',
  nameExisted: 'ảnh đã tồn tại',
  notFound: 'ảnh không tồn tại',
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
};
