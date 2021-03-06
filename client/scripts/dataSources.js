"use strict";
function DataSources(){
	this.levels = async function() {
		return [
			{name: "Royaume champignon"},
			{name: "Jungle"},
			{name: "Jungle Hardcore"},
		]
	};

	this.music = async function() {
		return [
			{
				"name": "Credits Roll",
				"duration": 206060,
				"bpm": 106,
				"start_offset": 537,
				"src": "songs/music1.mp3"
			},
			{
				"name": "Double Cherry Pass",
				"duration": 142870,
				"bpm": 114,
				"start_offset": 559,
				"src": "songs/music2.mp3"
			},
			{
				"name": "Nightcall",
				"duration": 256960,
				"bpm": 91.1,
				"start_offset": 10850,
				"src": "songs/nightcall.mp3"
			},
			{
				"name": "Short haha",
				"duration": 1008,
				"bpm": false,
				"start_offset": false,
				"src": "songs/short.mp3"
			},
			{
				"name": "Double Double Cherry Pass",
				"duration": 142870,
				"bpm": 228.15,
				"start_offset": 559,
				"src": "songs/music2.mp3"
			},
		]
	};
}