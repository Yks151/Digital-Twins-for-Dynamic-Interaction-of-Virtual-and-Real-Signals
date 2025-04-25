# Digital Twins for Dynamic Interaction of Virtual and Real Signals

![MATLAB](https://img.shields.io/badge/MATLAB-R2023a%2B-blue)
![License](https://img.shields.io/badge/License-MIT-green)

基于粒子滤波的数字孪生动态交互系统 | Particle Filter-based Digital Twin System

## 📖 项目概述

本仓库实现了一个基于粒子滤波（Particle Filter）的数字孪生系统，用于轴承故障的动态虚拟-现实信号交互与诊断。主要特点：

- 无需真实故障样本即可实现故障诊断
- 支持内圈/外圈/滚动体三类典型轴承故障模拟
- 包含完整的粒子滤波参数调优框架
- 提供状态空间建模与信号分析工具

## 🚀 核心功能

### 故障模拟模块
| 文件 | 功能描述 |
|------|----------|
| `Inner_fault.m` | 内圈故障信号生成 |
| `Outer_fault.m` | 外圈故障信号生成 |
| `Roll_fault.m` | 滚动体故障信号生成 |
| `vdp1009_state_space.m` | 范德波尔振子状态空间模型 |

### 粒子滤波核心
```matlab
% 粒子滤波基本流程示例
[particles, weights] = initialize_particles();
for k = 1:N
    particles = predictParticles(particles, dt);
    weights = updateWeights(measurements(k), particles);
    [particles, weights] = resample(particles, weights);
end

## 🛠️ 环境配置
MATLAB要求
MATLAB R2021a 或更高版本
Signal Processing Toolbox
Statistics and Machine Learning Toolbox

