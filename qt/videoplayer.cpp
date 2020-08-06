/****************************************************************************
**
** Copyright (C) 2015 The Qt Company Ltd.
** Contact: http://www.qt.io/licensing/
**
** This file is part of the examples of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:BSD$
** You may use this file under the terms of the BSD license as follows:
**
** "Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
**   * Redistributions of source code must retain the above copyright
**     notice, this list of conditions and the following disclaimer.
**   * Redistributions in binary form must reproduce the above copyright
**     notice, this list of conditions and the following disclaimer in
**     the documentation and/or other materials provided with the
**     distribution.
**   * Neither the name of The Qt Company Ltd nor the names of its
**     contributors may be used to endorse or promote products derived
**     from this software without specific prior written permission.
**
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
**
** $QT_END_LICENSE$
**
****************************************************************************/

#include "videoplayer.h"
#include "ui_videoplayer.h"
#include <QtWidgets>
#include <qvideowidget.h>
#include <qvideosurfaceformat.h>
#include "QFile"
#include "QTextStream"
#include "QString"
#include "QComboBox"
#include "QMessageBox"
#include "QProcess"

#include <QtCharts/QChartView>
#include <QtCharts/QAbstractBarSeries>
#include <QtCharts/QPercentBarSeries>
#include <QtCharts/QStackedBarSeries>
#include <QtCharts/QBarSeries>
#include <QtCharts/QBarSet>
#include <QtCharts/QLineSeries>
#include <QtCharts/QSplineSeries>
#include <QtCharts/QScatterSeries>
#include <QtCharts/QLegend>
#include <QtWidgets/QGridLayout>
#include <QtWidgets/QFormLayout>
#include <QtWidgets/QComboBox>
#include <QtWidgets/QSpinBox>
#include <QtWidgets/QCheckBox>
#include <QtWidgets/QGroupBox>
#include <QtWidgets/QLabel>
#include <QtCharts/QBarCategoryAxis>
#include <QtWidgets/QApplication>
#include <QtCharts/QValueAxis>

QString fileName;
static QProcess *_process;
QStringList _processFileList;

VideoPlayer::VideoPlayer(QWidget *parent)
    : QWidget(parent)
    , ui(new Ui::VideoPlayer)
    , mediaPlayer(0, QMediaPlayer::VideoSurface)
    , mediaPlayer_2(0, QMediaPlayer::VideoSurface)
    , mediaPlayer_3(0, QMediaPlayer::VideoSurface)
    , mediaPlayer_4(0, QMediaPlayer::VideoSurface)
    , mediaPlayer_5(0, QMediaPlayer::VideoSurface)
{
    ui->setupUi(this);

    _process = new QProcess;
    connect(_process, SIGNAL(finished(int, QProcess::ExitStatus)),this, SLOT(processFinishedSlot(int, QProcess::ExitStatus)));

    ui->openButton->setText("Open...");
    connect(ui->openButton, SIGNAL(clicked()), this, SLOT(openFile()));


    ui->playButton->setEnabled(false);
    ui->playButton->setIcon(style()->standardIcon(QStyle::SP_MediaPlay));

    connect(ui->playButton, SIGNAL(clicked()), this, SLOT(play()));

    ui->playButton_2->setEnabled(false);
    ui->playButton_2->setIcon(style()->standardIcon(QStyle::SP_MediaPlay));

    connect(ui->playButton_2, SIGNAL(clicked()), this, SLOT(play_particle()));

    ui->playButton_3->setEnabled(false);
    ui->playButton_3->setIcon(style()->standardIcon(QStyle::SP_MediaPlay));

    connect(ui->playButton_3, SIGNAL(clicked()), this, SLOT(play_particle_2()));


    ui->positionSlider->setRange(0, 0);
    connect(ui->positionSlider, SIGNAL(sliderMoved(int)), this, SLOT(setPosition(int)));

    ui->positionSlider_2->setRange(0, 0);
    connect(ui->positionSlider_2, SIGNAL(sliderMoved(int)), this, SLOT(setPosition_particle(int)));

    ui->positionSlider_3->setRange(0, 0);
    connect(ui->positionSlider_3, SIGNAL(sliderMoved(int)), this, SLOT(setPosition_particle_2(int)));

    mediaPlayer.setVideoOutput(ui->widget_1);
    mediaPlayer_2.setVideoOutput(ui->widget_2);
    mediaPlayer_3.setVideoOutput(ui->widget_3);
    mediaPlayer_4.setVideoOutput(ui->widget_4);
    mediaPlayer_5.setVideoOutput(ui->widget_5);


    connect(ui->comboBox, SIGNAL(activated(const QString &)), this,SLOT(particle()));
    connect(ui->comboBox_2, SIGNAL(activated(const QString &)), this,SLOT(particle_time()));

    connect(&mediaPlayer, SIGNAL(stateChanged(QMediaPlayer::State)),this, SLOT(mediaStateChanged(QMediaPlayer::State)));
    connect(&mediaPlayer, SIGNAL(positionChanged(qint64)), this, SLOT(positionChanged(qint64)));
    connect(&mediaPlayer, SIGNAL(durationChanged(qint64)), this, SLOT(durationChanged(qint64)));

    connect(&mediaPlayer_4, SIGNAL(stateChanged(QMediaPlayer::State)), this, SLOT(mediaStateChanged_particle(QMediaPlayer::State)));
    connect(&mediaPlayer_4, SIGNAL(positionChanged(qint64)), this, SLOT(positionChanged_particle(qint64)));
    connect(&mediaPlayer_4, SIGNAL(durationChanged(qint64)), this, SLOT(durationChanged_particle(qint64)));

    connect(&mediaPlayer_5, SIGNAL(stateChanged(QMediaPlayer::State)), this, SLOT(mediaStateChanged_particle_2(QMediaPlayer::State)));
    connect(&mediaPlayer_5, SIGNAL(positionChanged(qint64)), this, SLOT(positionChanged_particle_2(qint64)));
    connect(&mediaPlayer_5, SIGNAL(durationChanged(qint64)), this, SLOT(durationChanged_particle_2(qint64)));


    connect(&mediaPlayer, SIGNAL(error(QMediaPlayer::Error)), this, SLOT(handleError()));

    /*int window_width = width();
    int window_height = height();
    int image_width = m_pixmap.width();
    int image_height = m_pixmap.height();
    int r1 = window_width / image_width;
    int r2 = window_height / image_height;
    int r = qMin(r1, r2);
    int offset_x = (window_width - r * image_width) / 2;
    int offset_y = (window_height - r * image_height) / 2;
    painter.translate(offset_x, offset_y);
    painter.scale(r, r);
    painter.drawPixmap(0, 0, m_pixmap);
*/



}

VideoPlayer::~VideoPlayer()
{
}

void VideoPlayer::openFile()
{
    fileName = QFileDialog::getOpenFileName(this, tr("Open Movie"),QDir::homePath());
    //fileName = QFileDialog::getExistingDirectory();
    QString fileName_2 =fileName.mid(0,fileName.lastIndexOf("."));
    fileName_2+="_1.avi";
    QString fileName_3 =fileName.mid(0,fileName.lastIndexOf("."));
    fileName_3+="_2.avi";
    if (!fileName.isEmpty()) {
        mediaPlayer.setMedia(QUrl::fromLocalFile(fileName));
        mediaPlayer_2.setMedia(QUrl::fromLocalFile(fileName_2));
        mediaPlayer_3.setMedia(QUrl::fromLocalFile(fileName_3));
        ui->playButton->setEnabled(true);
    }

    ui->comboBox->clear();
    QString combo=fileName.mid(0,fileName.lastIndexOf("."));
    QString Line;

    //宣告檔案
    QFile file(combo);
    //Open
    file.open(QIODevice::ReadOnly);
    QTextStream streamread(&file);
    //讀
    //一次讀一行的寫法
    while(!streamread.atEnd())
    {
        Line = streamread.readLine();
        ui->comboBox->addItem(Line);
    }
    file.close();

    // /home/ppcb/MATLAB/R2015b/bin/glnxa64/MATLAB -nodesktop -nosplash -r 'run /home/ppcb/Downloads/particle_cell_code/main.m'

    //_process->start("/bin/sh", QStringList()<< "-c"<<"python3 prediction.py /home/ppcb/tensorflow/mask_rcnn/dataset/cell_particle/model1/predict");
}

void VideoPlayer::play()
{
    switch(mediaPlayer.state()) {
    case QMediaPlayer::PlayingState:
        mediaPlayer.pause();
        mediaPlayer_2.pause();
        mediaPlayer_3.pause();
        break;
    default:
        mediaPlayer.play();
        mediaPlayer_2.play();
        mediaPlayer_3.play();
        break;
    }
}

void VideoPlayer::particle()
{
    if (!ui->comboBox->currentText().isEmpty()) {
        QString particleName = ui->comboBox->currentText();
        particleName+=".avi";
        QString particlePath=fileName.mid(0,fileName.lastIndexOf("/")+1);
        particlePath+=particleName;
        mediaPlayer_4.setMedia(QUrl::fromLocalFile(particlePath));
        ui->playButton_2->setEnabled(true);

        QString particleName_2 = ui->comboBox->currentText();
        particleName_2+=".avi";
        QString particlePath_2=fileName.mid(0,fileName.lastIndexOf("/")+1);
        particlePath_2+="recordVideo/";
        particlePath_2+=particleName_2;
        mediaPlayer_5.setMedia(QUrl::fromLocalFile(particlePath_2));
        ui->playButton_3->setEnabled(true);

        QString cahrtPath=fileName.mid(0,fileName.lastIndexOf("/")+1);
        cahrtPath+="ParticleandCellProcessDistance.txt";

        createLineChart(cahrtPath,ui->comboBox->currentIndex());

        QString imagePath=fileName.mid(0,fileName.lastIndexOf("/")+1);
        imagePath+="object";
        if( ui->comboBox->currentIndex()+1<10)
            imagePath+="0";
        imagePath+=QString::number(ui->comboBox->currentIndex()+1);
        imagePath+=".tiff";
        QImage *image=new QImage(imagePath);
        QPixmap *pixmap=new QPixmap();
        int with = ui->label->width();
        int height = ui->label->height();
        pixmap->convertFromImage(*image);
        QPixmap fitpixmap = pixmap->scaled(with, height, Qt::KeepAspectRatio, Qt::SmoothTransformation);
        //ui->label->setScaledContents(true);
        //ui->label->setGeometry(100,0,1000,700);
        ui->label->setPixmap(fitpixmap);
        ui->label->setAlignment(Qt::AlignCenter);
    }
}

void VideoPlayer::particle_time()
{
    if (!ui->comboBox_2->currentText().isEmpty()) {
        QString imagePath=fileName.mid(0,fileName.lastIndexOf("/")+1);
        imagePath+="circled/";
        imagePath+="object";
        imagePath+=QString::number(ui->comboBox->currentIndex()+1);
        imagePath+="/";
        imagePath+="image";
        if( ui->comboBox_2->currentIndex()+1<10)
            imagePath+="0";
        imagePath+=QString::number(ui->comboBox_2->currentIndex()+1);
        imagePath+=".tif";
        qDebug()<<imagePath;
        QImage *image=new QImage(imagePath);
        QPixmap *pixmap=new QPixmap();
        int width = ui->label_2->width();
        int height = ui->label_2->height();
        pixmap->convertFromImage(*image);
        QPixmap fitpixmap = pixmap->scaled(width, height, Qt::KeepAspectRatio, Qt::SmoothTransformation);
        //ui->label->setScaledContents(true);
        //ui->label->setGeometry(100,0,1000,700);
        ui->label_2->setPixmap(fitpixmap);
        ui->label_2->setAlignment(Qt::AlignCenter);

        QString imagePath_2=fileName.mid(0,fileName.lastIndexOf("/")+1);
        imagePath_2+="c2/";
        imagePath_2+="object";
        imagePath_2+=QString::number(ui->comboBox->currentIndex()+1);
        imagePath_2+="/";
        imagePath_2+="image";
        if( ui->comboBox_2->currentIndex()+1<10)
            imagePath_2+="0";
        imagePath_2+=QString::number(ui->comboBox_2->currentIndex()+1);
        imagePath_2+=".tif";
        qDebug()<<imagePath_2;
        QImage *image_2=new QImage(imagePath_2);
        QPixmap *pixmap_2=new QPixmap();
        int width_2 = ui->label_3->width();
        int height_2 = ui->label_3->height();
        pixmap_2->convertFromImage(*image_2);
        QPixmap fitpixmap_2 = pixmap_2->scaled(width_2, height_2, Qt::KeepAspectRatio, Qt::SmoothTransformation);
        //ui->label->setScaledContents(true);
        //ui->label->setGeometry(100,0,1000,700);
        ui->label_3->setPixmap(fitpixmap_2);
        ui->label_3->setAlignment(Qt::AlignCenter);
    }
}

void VideoPlayer::play_particle()
{
    switch(mediaPlayer_4.state()) {
    case QMediaPlayer::PlayingState:
        mediaPlayer_4.pause();
        break;
    default:
        mediaPlayer_4.play();
        break;
    }
}

void VideoPlayer::play_particle_2()
{
    switch(mediaPlayer_5.state()) {
    case QMediaPlayer::PlayingState:
        mediaPlayer_5.pause();
        break;
    default:
        mediaPlayer_5.play();
        break;
    }
}

void VideoPlayer::mediaStateChanged(QMediaPlayer::State state)
{
    switch(state) {
    case QMediaPlayer::PlayingState:
        ui->playButton->setIcon(style()->standardIcon(QStyle::SP_MediaPause));
        break;
    default:
        ui->playButton->setIcon(style()->standardIcon(QStyle::SP_MediaPlay));
        break;
    }
}

void VideoPlayer::mediaStateChanged_particle(QMediaPlayer::State state)
{
    switch(state) {
    case QMediaPlayer::PlayingState:
        ui->playButton_2->setIcon(style()->standardIcon(QStyle::SP_MediaPause));
        break;
    default:
        ui->playButton_2->setIcon(style()->standardIcon(QStyle::SP_MediaPlay));
        break;
    }
}

void VideoPlayer::mediaStateChanged_particle_2(QMediaPlayer::State state)
{
    switch(state) {
    case QMediaPlayer::PlayingState:
        ui->playButton_3->setIcon(style()->standardIcon(QStyle::SP_MediaPause));
        break;
    default:
        ui->playButton_3->setIcon(style()->standardIcon(QStyle::SP_MediaPlay));
        break;
    }
}

void VideoPlayer::positionChanged(qint64 position)
{
    ui->positionSlider->setValue(position);
}

void VideoPlayer::positionChanged_particle(qint64 position)
{
    ui->positionSlider_2->setValue(position);
}

void VideoPlayer::positionChanged_particle_2(qint64 position)
{
    ui->positionSlider_3->setValue(position);
}

void VideoPlayer::durationChanged(qint64 duration)
{
    ui->positionSlider->setRange(0, duration);
}

void VideoPlayer::durationChanged_particle(qint64 duration)
{
    ui->positionSlider_2->setRange(0, duration);
}

void VideoPlayer::durationChanged_particle_2(qint64 duration)
{
    ui->positionSlider_3->setRange(0, duration);
}

void VideoPlayer::setPosition(int position)
{
    mediaPlayer.setPosition(position);
    mediaPlayer_2.setPosition(position);
    mediaPlayer_3.setPosition(position);
}

void VideoPlayer::setPosition_particle(int position)
{
    mediaPlayer_4.setPosition(position);
}

void VideoPlayer::setPosition_particle_2(int position)
{
    mediaPlayer_5.setPosition(position);
}

void VideoPlayer::handleError()
{
    ui->playButton->setEnabled(false);
    QMessageBox::warning(this,tr("Error"),mediaPlayer.errorString());
}

QChart *VideoPlayer::createLineChart(QString path, int index) const
{
    QChart *chart = new QChart();
    QString title="particle";
    title+=QString::number(ui->comboBox->currentIndex()+1,10);
    chart->setTitle(title);
    //![1]

    //![2]
    QString name("Series ");

    QString line;
    //宣告檔案
    QFile file(path);
    //Open
    file.open(QIODevice::ReadOnly);
    QTextStream streamread(&file);
    //讀
    //一次讀一行的寫法
    QLineSeries *series = new QLineSeries(chart);
    for ( int i=0; i<=index; i++)
        line = streamread.readLine();
    //close
    file.close();
    QStringList  particlelist  = line.split(' ');

    ui->comboBox_2->clear();
    for (int i=0; i<particlelist.length(); i++)
        if (!particlelist.at(i).isEmpty())
        {
            series->append(i+1,particlelist.at(i).toDouble());
            ui->comboBox_2->addItem(QString::number(i+1,10));
        }


    chart->addSeries(series);



    //別忘記把座標軸添加到chart
    chart->createDefaultAxes();
    QValueAxis *axisX = new QValueAxis;
    axisX->setTitleText("time"); //設置X座標名字
    QValueAxis *axisY = new QValueAxis;
    axisY->setTitleText("distance");

    chart->addAxis(axisX, Qt::AlignBottom);  //並且XY軸的位置是上和右
    chart->addAxis(axisY, Qt::AlignLeft);



    //series->attachAxis(axisY);
    //series->attachAxis(axisX);

    chart->setAnimationOptions(QChart::SeriesAnimations);
    chart->legend()->hide(); //隱藏圖例



/*    axisX->setRange(0,particlelist.length()-1);   //設置X座標範圍
    axisX->setTitleText("time"); //設置X座標名字

    axisY->setRange(0,int(particleMax+5));
    axisY->setTitleText("distance");

    //別忘記把座標軸添加到chart
    chart->setAxisX(axisX, series);  //並且XY軸的位置是上和右
    chart->setAxisY(axisY, series);
*/
    ui->linechart->setChart(chart);
    ui->linechart->setRenderHint(QPainter::Antialiasing);
}

void VideoPlayer::on_SaveChart_clicked()
{
    QScreen * screen = QGuiApplication::primaryScreen();
    QPixmap p = screen->grabWindow(ui->linechart->winId());
    QImage image = p.toImage();
    QString imageName=fileName.mid(0,fileName.lastIndexOf("/")+1);
    imageName+="chart/";
    imageName+=ui->comboBox->currentText();
    imageName+=".jpeg";
    image.save(imageName);

    QMessageBox::information(this, "Save chart","Success!");
}

void VideoPlayer::processFinishedSlot(int,QProcess::ExitStatus)
{
    /*if (_processFileList.size()>=1)
    {
        _processFileList.removeAt(0);
        QString status;
        status.sprintf("%s : %d/%d%s", "Running...\nNumber of Files", pathstring.size()*pathstring2.size()-_processFileList.size(), pathstring.size()*pathstring2.size(),"\nIt takes about 3 minutes for each comparison file......");
        ui->status->setText(status);
    }



        if (_processFileList.size() == 0)
        {
            emit allFinishedSignal(0);
            _processFileList.clear();
            QMessageBox::information(this, "8point N2N","Success!");
            ui->status->setText("Success!");


            ui->openDir->setVisible(true);
            return;
        }


        if (_processFileList.size() >= 1)
        {
            QString fileName = _processFileList.at(0);
            QStringList arguments;
            arguments << "-c" << fileName;
            _process->start("/bin/sh", arguments);
        }*/
    QMessageBox::information(this, "P&C","Success!");
}

