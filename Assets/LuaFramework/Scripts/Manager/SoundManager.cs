using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using LuaInterface;
namespace LuaFramework
{
    public class SoundManager : Manager
    {
        private static new AudioSource audio;//��������Դ
        private static AudioSource cardSounPlay;//��������
        private static AudioSource ActionSounPlay;//��������
        private static AudioSource MessageSounPlay;//��Ϣ����
        private Hashtable sounds = new Hashtable();
        Hashtable OnGetAudioClipList = new Hashtable();//���ڼ����е���Ƶ
        public float MusicVolume = 1f;//��������
        public float EffectVolume = 1f;//��Ч����
        void Start()
        {
            audio = GameObject.Find("SoundsContainer/MyAudio").GetComponent<AudioSource>();
            cardSounPlay = GameObject.Find("SoundsContainer/cardSoundPlay").GetComponent<AudioSource>();
            ActionSounPlay = GameObject.Find("SoundsContainer/ActionSound").GetComponent<AudioSource>();
            MessageSounPlay = GameObject.Find("SoundsContainer/MessageSound").GetComponent<AudioSource>();
        }
        #region ����Լ��ķ��������ǲ���
        /// <summary>
        /// ���һ������
        /// </summary>
        void Add(string key, AudioClip value)
        {
            if (sounds[key] != null || value == null) return;
            sounds.Add(key, value);
        }

        /// <summary>
        /// ��ȡһ������
        /// </summary>
        AudioClip Get(string key)
        {
            if (sounds[key] == null) return null;
            return sounds[key] as AudioClip;
        }

        /// <summary>
        /// ����һ����Ƶ
        /// </summary>
        public AudioClip LoadAudioClip(string path)
        {
            AudioClip ac = Get(path);
            if (ac == null)
            {
                ac = (AudioClip)Resources.Load(path, typeof(AudioClip));
                Add(path, ac);
            }
            return ac;
        }

        /// <summary>
        /// �Ƿ񲥷ű������֣�Ĭ����1������
        /// </summary>
        /// <returns></returns>
        public bool CanPlayBackSound()
        {
            string key = AppConst.AppPrefix + "BackSound";
            int i = PlayerPrefs.GetInt(key, 1);
            return i == 1;
        }

        /// <summary>
        /// ���ű�������
        /// </summary>
        /// <param name="canPlay"></param>
        public void PlayBacksound(string name, bool canPlay)
        {
            if (audio.clip != null)
            {
                if (name.IndexOf(audio.clip.name) > -1)
                {
                    if (!canPlay)
                    {
                        audio.Stop();
                        audio.clip = null;
                        Util.ClearMemory();
                    }
                    return;
                }
            }
            if (canPlay)
            {
                audio.loop = true;
                audio.clip = LoadAudioClip(name);
                audio.Play();
            }
            else
            {
                audio.Stop();
                audio.clip = null;
                Util.ClearMemory();
            }
        }

        /// <summary>
        /// �Ƿ񲥷���Ч,Ĭ����1������
        /// </summary>
        /// <returns></returns>
        public bool CanPlaySoundEffect()
        {
            string key = AppConst.AppPrefix + "SoundEffect";
            int i = PlayerPrefs.GetInt(key, 1);
            return i == 1;
        }

        /// <summary>
        /// ������Ƶ����
        /// </summary>
        /// <param name="clip"></param>
        /// <param name="position"></param>
        public void Play(AudioClip clip, Vector3 position)
        {
            if (!CanPlaySoundEffect()) return;
            AudioSource.PlayClipAtPoint(clip, position);
        }
        #endregion
        /// <summary>
        /// ���Ŵ�������
        /// </summary>
        public void playSound(int cardPoint, int sex)
        {
            string path = "Assets/Project/Sounds/";
            if (sex == 1)
            {
                path += "boy/" + (cardPoint + 1);
            }
            else
            {
                path += "girl/" + (cardPoint + 1);
            }
            Commom(path + ".wav", cardSounPlay, false, EffectVolume);
        }
        public void playMessageBoxSound(int codeIndex, int sex)
        {
            string path;
            if (sex == 1)
                path = "Assets/Project/Sounds/other/boy/" + codeIndex;
            else
                path = "Assets/Project/Sounds/other/women/" + codeIndex;
            Commom(path + ".mp3", MessageSounPlay, false, EffectVolume);
        }

        public void playBGM(int type)
        {
            string path = "";
            switch (type)
            {
                case 0:
                    audio.loop = false;
                    audio.Stop();
                    return;
                case 1:
                    path = "Assets/Project/Sounds/BackAudio1";
                    break;
                case 2:
                    path = "Assets/Project/Sounds/mjBGM";
                    break;
            }
            Commom(path + ".mp3", audio, true, MusicVolume);
        }
        public void playSoundByAction(string str, int sex)
        {
            string path = "Assets/Project/Sounds/";
            if (sex == 1)
            {
                path += "boy/" + str;
            }
            else
            {
                path += "girl/" + str;
            }
            Commom(path + ".wav", ActionSounPlay, false, EffectVolume);
        }
        public void playSoundByActionButton(int type)
        {
            string path = "Assets/Project/Sounds/other/";
            //��ť
            if (type == 1)
            {
                path += "clickbutton.mp3";
                //����
            }
            else if (type == 2)
            {
                path += "dice.mp3";
                //׼��
            }
            else if (type == 3)
            {
                path += "ready.mp3";
                //����
            }
            else if (type == 4)
            {
                //path += "tileout";
                path += "out.wav";
                //����
            }
            else if (type == 5)
            {
                path += "select.mp3";
            }
            else if (type == 6)
            {
                //path += "tileout";
                path += "tileout.mp3";
                //����
            }
            else if (type == 7)
            {
                //path += "tileout";
                path += "touzi.wav";
                //����
            }
            Commom(path, ActionSounPlay, false, EffectVolume);
        }
        void Commom(string path, AudioSource audiosource, bool isloop, float Volume)
        {
            AudioClip temp = (AudioClip)sounds[path];
            if (temp == null)
            {
                //�����ظ�����
                if (!OnGetAudioClipList.Contains(path))
                {
                    OnGetAudioClipList[path] = path;
                    
                    GetAudioClip(path, "sounds"+path.Substring(path.LastIndexOf('.')+1), audiosource, isloop, Volume);
                }
            }
            else
            {
                audiosource.volume = Volume;
                audiosource.clip = temp;
                audiosource.loop = isloop;
                audiosource.Play();
            }
        }

        public void GetAudioClip(string assetName, string abName, AudioSource audiosource, bool isloop, float Volume, LuaFunction func = null)
        {
            abName += AppConst.ExtName;
            ResManager.LoadPrefab<AudioClip>(abName, assetName, delegate (Object[] objs)
            {
                if (objs.Length == 0) return;
                AudioClip prefab = objs[0] as AudioClip;
                if (prefab == null) return;
                AudioClip audioclip = Instantiate(prefab);
                sounds.Add(assetName, audioclip);
                audiosource.volume = Volume;
                audiosource.clip = audioclip;
                audiosource.loop = isloop;
                audiosource.Play();
                OnGetAudioClipList.Remove(assetName);
                if (func != null) func.Call(audioclip);
                Debug.LogWarning("CreateAudioClip::>> " + name + " " + prefab);
            });
        }
    }
}

