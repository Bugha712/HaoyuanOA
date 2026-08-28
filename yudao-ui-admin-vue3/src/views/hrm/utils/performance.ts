import type {
  AssessmentConfigVO,
  AssessmentDimensionVO
} from '@/api/hrm/performance/config/assessment-template'
import {
  HrmPerformanceBonusPenaltyType,
  HrmPerformanceScoreCalculation,
  HrmPerformanceUpperLimitType
} from '@/views/hrm/utils/constants'

/** 创建默认考核配置 */
export function createDefaultAssessmentConfig(): AssessmentConfigVO {
  return {
    name: '',
    scoreCalculation: HrmPerformanceScoreCalculation.WEIGHTED,
    upperLimitType: HrmPerformanceUpperLimitType.UNIFIED,
    upperLimitScore: 100,
    dimensions: [],
    bonusPenaltyItems: []
  }
}

/** 校验考核维度和指标配置 */
export function validateAssessmentConfig(config?: AssessmentConfigVO) {
  const dimensions = config?.dimensions || []
  if (!dimensions.length) {
    return '至少需要一个考核维度'
  }
  const dimensionNames = new Set<string>()
  const quotaNames = new Set<string>()
  let dimensionTotalWeight = 0
  for (const dimension of dimensions) {
    const dimensionName = dimension.name?.trim()
    if (!dimensionName) {
      return '维度名称不能为空'
    }
    if (dimensionNames.has(dimensionName)) {
      return `维度名称（${dimensionName}）重复`
    }
    dimensionNames.add(dimensionName)
    if (!isValidWeight(dimension.weight)) {
      return `维度（${dimensionName}）权重必须在 0% 到 100% 之间`
    }
    dimensionTotalWeight += dimension.weight as number

    const quotas = dimension.quotas || []
    if (!quotas.length) {
      return `维度（${dimensionName}）至少需要一个指标`
    }
    let quotaTotalWeight = 0
    for (const quota of quotas) {
      const quotaName = quota.name?.trim()
      if (!quotaName) {
        return '指标名称不能为空'
      }
      if (!quota.standard?.trim()) {
        return `指标（${quotaName}）考核标准不能为空`
      }
      if (quotaNames.has(quotaName)) {
        return `指标名称（${quotaName}）重复`
      }
      quotaNames.add(quotaName)
      if (!isValidWeight(quota.weight)) {
        return `指标（${quotaName}）权重必须在 0% 到 100% 之间`
      }
      if (quota.scoreType === undefined || quota.scoreType === null) {
        return `指标（${quotaName}）评分方式不能为空`
      }
      quotaTotalWeight += quota.weight as number
    }
    if (dimension.allowEdit) {
      if (quotaTotalWeight > 100) {
        return `可编辑维度（${dimensionName}）指标权重总和不能大于 100%`
      }
    } else if (!isHundred(quotaTotalWeight)) {
      return `维度（${dimensionName}）指标权重总和必须等于 100%`
    }
  }
  if (!isHundred(dimensionTotalWeight)) {
    return '维度权重总和必须等于 100%'
  }
  // 校验加减分项配置
  const bonusPenaltyItems = config?.bonusPenaltyItems || []
  const bonusPenaltyKeys = new Set<string>()
  for (const item of bonusPenaltyItems) {
    const itemName = item.name?.trim()
    const itemKey = item.key?.trim()
    if (!itemKey) {
      return '加减分项标识不能为空'
    }
    if (!itemName) {
      return '加减分项名称不能为空'
    }
    if (bonusPenaltyKeys.has(itemKey)) {
      return `加减分项标识（${itemKey}）重复`
    }
    bonusPenaltyKeys.add(itemKey)
    if (item.type !== HrmPerformanceBonusPenaltyType.BONUS && item.type !== HrmPerformanceBonusPenaltyType.DEDUCT) {
      return `加减分项（${itemName}）类型只能为加分或减分`
    }
    const minScore = Number(item.minScore)
    const maxScore = Number(item.maxScore)
    if (!Number.isFinite(minScore) || !Number.isFinite(maxScore)) {
      return `加减分项（${itemName}）分数范围必须为数字`
    }
    if (minScore < 0 || maxScore < minScore) {
      return `加减分项（${itemName}）分数范围为最低分数应大于等于 0，且最高分数不低于最低分数`
    }
  }
}

/** 创建默认加减分项 */
export function createDefaultBonusPenaltyItem() {
  return {
    key: `bp_${Date.now()}`,
    type: HrmPerformanceBonusPenaltyType.BONUS,
    name: '',
    minScore: 1,
    maxScore: 5,
    remark: ''
  }
}

/** 复制考核配置，避免计划编辑影响原模板数据 */
export function cloneAssessmentConfig(config: AssessmentConfigVO): AssessmentConfigVO {
  return {
    name: config.name,
    scoreCalculation: config.scoreCalculation,
    upperLimitType: config.upperLimitType,
    upperLimitScore: config.upperLimitScore,
    dimensions: (config.dimensions || []).map((dimension) => ({
      ...dimension,
      quotas: (dimension.quotas || []).map((quota) => ({ ...quota }))
    })),
    bonusPenaltyItems: (config.bonusPenaltyItems || []).map((item) => ({ ...item }))
  }
}

/** 获得指标权重合计 */
export function getQuotaWeightTotal(dimension: AssessmentDimensionVO) {
  return (dimension.quotas || []).reduce((total, quota) => total + Number(quota.weight || 0), 0)
}

/** 判断权重是否为 100% */
export function isHundred(weight: number) {
  return Math.abs(weight - 100) < 0.001
}

/** 判断绩效评分是否合法 */
export function isValidPerformanceScore(score: number) {
  return Number.isFinite(score) && score >= 0 && score <= 100 && hasAtMostTwoDecimals(score)
}

/** 判断绩效系数是否合法 */
export function isValidPerformanceCoefficient(coefficient: number) {
  return Number.isFinite(coefficient) && coefficient >= 0 && hasAtMostTwoDecimals(coefficient)
}

/** 判断两个数值是否相等，避免浮点数计算误差 */
export function isSameNumber(left: number, right: number) {
  return Math.abs(left - right) < 0.000001
}

/** 判断权重是否合法 */
function isValidWeight(weight?: number) {
  return weight !== undefined && weight !== null && weight >= 0 && weight <= 100
}

/** 判断数值是否最多保留两位小数 */
function hasAtMostTwoDecimals(value: number) {
  return isSameNumber(value * 100, Math.round(value * 100))
}
