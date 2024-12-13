const mongoose = require('mongoose');

const { Schema } = mongoose;
const { paginate } = require('./plugins');

const mediaSchema = new Schema(
  {
    type: {
      type: String,
      required: true,
      enum: ['image', 'video'],
    },
    url: {
      type: String,
      required: true,
    },
  },
  { _id: false }
);

const postSchema = new Schema({
  userId: {
    type: Schema.Types.ObjectId,
    ref: 'User',
    required: true,
  },
  content: {
    type: String,
    required: true,
  },
  media: [mediaSchema],
  journeyId: {
    type: Schema.Types.ObjectId,
    ref: 'Journey',
    required: true,
  },
  createdAt: {
    type: Number,
    required: true,
  },
  updatedAt: {
    type: Number,
    required: true,
  },
  commentsCount: {
    type: Number,
    default: 0,
  },
  likesCount: {
    type: Number,
    default: 0,
  },
});

postSchema.methods.addLike = async function () {
  this.likesCount += 1;
  return this.save();
};

postSchema.methods.removeLike = async function () {
  this.likesCount -= 1;
  await this.save();
};

postSchema.methods.addComment = async function () {
  this.commentsCount += 1;
  await this.save();
};

postSchema.methods.removeComment = async function () {
  this.commentsCount -= 1;
  await this.save();
};

postSchema.plugin(paginate);
const Post = mongoose.model('Post', postSchema);

module.exports = Post;
