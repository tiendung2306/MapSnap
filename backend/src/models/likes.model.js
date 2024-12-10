const mongoose = require('mongoose');

const { Schema } = mongoose;

const likeSchema = new Schema({
  postId: {
    type: Schema.Types.ObjectId,
    ref: 'Post',
    required: true,
  },
  userId: {
    type: Schema.Types.ObjectId,
    ref: 'User',
    required: true,
  },
  createdAt: {
    type: Number,
    required: true,
  },
});

const Like = mongoose.model('Like', likeSchema);

module.exports = Like;
