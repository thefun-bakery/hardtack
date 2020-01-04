require 'hardtack_file_helper'
require 'json'

module ApiResponse
  def self.home(val_home)
    val_home.to_json( :only => [:name, :desc, :bgcolor])
  end

  def self.emotion(val_emotion)
    return nil if val_emotion.nil?
    emotion_map = self.load_emotion_map
    self._emotion(val_emotion, emotion_map)
  end

  def self._emotion(val_emotion, emotion_map)
    user_image_url = ""
    if not (val_emotion.files.nil? or val_emotion.files.length == 0)
      user_image_url = HardtackFileHelper.get_download_url(val_emotion.files[0])
    end
    # NOTE, 이용자 파일의 무조건 첫번째 이미지만 취급한다.
    {
      id: val_emotion.id,
      emotion: val_emotion.emotion_key,
      emotion_url: emotion_map[val_emotion.emotion_key],
      tag: val_emotion.tag,
      user_image_url: user_image_url,
      created_at: val_emotion.created_at,
      updated_at: val_emotion.updated_at
    }
  end

  def self.emotion_list(emotions)
    emotion_map = self.load_emotion_map

    result = []
    for val_emotion in emotions do
      result.push(self._emotion(val_emotion, emotion_map))
    end
    result
  end

  def self.main(val_main)
    {
      user: {
        id: val_main.home.user_id
      },
      home: {
        id: val_main.home.id,
        name: val_main.home.name,
        desc: val_main.home.desc,
        bgcolor: val_main.home.bgcolor,
        visit: val_main.home.home_visit_count.nil? \
          ? 0 : val_main.home.home_visit_count.visit_count
      },
      emotion: self.emotion(val_main.emotion)
    }
  end

  private

  def self.load_emotion_map
    # TODO emotion mapping을 매번 파일에서 읽고 있는데, 이건 별도로 분리하자
    file = File.join('assets', 'emotion-image.json')
    str_emotions = File.read(file)
    emotions = JSON.parse(str_emotions)
    self.get_emotion_map(emotions)
  end

  def self.get_emotion_map(emotions)
    result = {}
    for emotion in emotions do
      images = emotion['images']
      for image in images do
        key = image['key']
        svg = image['svg']
        png = image['png']
        lottie = image['lottie']
        result[key] = {svg: svg, lottie: lottie, png: png}
      end
    end

    result
  end
end
