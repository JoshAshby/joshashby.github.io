module App
  extend self

  def root()= Pathname.new(File.dirname(__FILE__)).join("../")

  DEFAULT_EXIF_KEYS = %w[
    Make
    Model
    Orientation
    Artist
    Copyright
    ExposureTime
    FNumber
    ISO
    DateTimeOriginal
    ShutterSpeedValue
    ApertureValue
    ExposureCompensation
    MeteringMode
    Flash
    FocalLength
    UserComment
    ExposureMode
    LensModel
    Lens
    DeviceManufacturer
    DeviceModel
    Aperture
    ShutterSpeed
  ]

  GPS_EXIF_KEYS = %w[
    GPSPosition
    GPSVersionID
    GPSLatitudeRef
    GPSLongitudeRef
    GPSAltitudeRef
    GPSTimeStamp
    GPSSatellites
    GPSStatus
    GPSMeasureMode
    GPSMapDatum
    GPSDateStamp
    GPSAltitude
    GPSDateTime
    GPSLatitude
    GPSLongitude
  ]
end
